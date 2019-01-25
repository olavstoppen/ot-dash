port module Updates exposing (update, urlParser)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Helpers exposing (getPageKey, sortTransport)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import List exposing (..)
import List.Extra as ListExtra
import Model exposing (..)
import Page.Birthday as Birthday
import Page.Instagram as Instagram
import Page.Lunch as Lunch
import Page.Slack as Slack
import Page.Transit as Transit
import Page.Weather as Weather
import Random
import Services exposing (..)
import Task
import Time exposing (..)
import Tuple exposing (..)
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser)



-- ---------------------------
-- UPDATE
-- ---------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        SetTimeZone zone ->
            let
                { here } =
                    model

                updatedHere =
                    { here | zone = zone }
            in
            ( { model | here = updatedHere }, Cmd.none )

        OnUrlRequest urlRequest ->
            ( model, handleUrlRequest model.key urlRequest )

        OnUrlChange url ->
            let
                urlPage =
                    Maybe.withDefault model.pages.active <|
                        UrlParser.parse (urlParser model.birthdays) url
            in
            ( updateActivePage urlPage model
                |> updatePageCountdown 30
            , Cmd.none
            )

        EverySecond now ->
            let
                updatedModel =
                    updateNow now model

                { pages } =
                    updatedModel

                nextCountdown =
                    pages.countdown - 1
            in
            if nextCountdown < 0 then
                ( updatePageCountdown 30 updatedModel
                , Nav.replaceUrl model.key <| (++) "/" <| getPageKey <| nextPage pages.available pages.active
                )

            else
                ( updatePageCountdown nextCountdown updatedModel, Cmd.none )

        EveryMinute _ ->
            ( model
            , Cmd.batch
                [ fetchPublicTransport UpdatePublicTransport model
                , fetchSlackEvents UpdateSlackEvents model
                , Random.generate UpdateMediaDigit oneToThirty
                ]
            )

        EveryHour _ ->
            ( model
            , Cmd.batch
                [ fetchWeather UpdateWeather model
                , fetchInstagram UpdateInstagram model
                , fetchSlackInfo UpdateSlackInfo model
                ]
            )

        EveryDay _ ->
            ( model
            , Cmd.batch
                [ fetchLunchMenu UpdateLunchMenu model
                , fetchBirthdays UpdateBirthdays model
                , fetchCalendar UpdateCalendar model
                ]
            )

        FetchAllData _ ->
            ( model
            , Cmd.batch
                [ fetchSlackEvents UpdateSlackEvents model
                , fetchWeather UpdateWeather model
                , fetchInstagram UpdateInstagram model
                , fetchPublicTransport UpdatePublicTransport model
                , fetchSlackInfo UpdateSlackInfo model
                , fetchLunchMenu UpdateLunchMenu model
                , fetchLunchMenu UpdateLunchMenu model
                , fetchBirthdays UpdateBirthdays model
                , fetchCalendar UpdateCalendar model
                , fetchSlackImgs UpdateSlackImgs model
                , fetchLunchImgs UpdateLunchImgs model
                , Random.generate UpdateMediaDigit oneToThirty
                ]
            )

        UpdateMediaDigit digit ->
            ( (setMedia <| setDigit digit) model, Cmd.none )

        UpdateSlackImgs res ->
            case res of
                Ok slackImgs ->
                    ( (setMedia <| setSlackImgs slackImgs) model, Cmd.none )

                Err err ->
                    ( model, Cmd.none )

        UpdateLunchImgs res ->
            case res of
                Ok lunchImgs ->
                    ( (setMedia <| setLunchImgs lunchImgs) model, Cmd.none )

                Err err ->
                    ( model, Cmd.none )

        UpdateCalendar res ->
            case res of
                Ok calendar ->
                    ( { model | calendar = Success calendar }, Cmd.none )

                Err err ->
                    ( { model | calendar = Failure err }, Cmd.none )

        UpdateBirthdays res ->
            case res of
                Ok birthdays ->
                    let
                        updatedBirthdays =
                            List.append birthdays
                                [ Person "Olavstoppen" "Dashboard" ""
                                ]

                        updatedAvailable =
                            List.map Birthday updatedBirthdays
                                |> List.append model.pages.available
                    in
                    ( { model | birthdays = Success updatedBirthdays }
                        |> updateAvailablePages updatedAvailable
                    , Cmd.none
                    )

                Err err ->
                    ( { model | birthdays = Failure err }, Cmd.none )

        UpdateSlackEvents res ->
            case res of
                Ok events ->
                    ( { model | slackEvents = Success events }, Cmd.none )

                Err err ->
                    ( { model | slackEvents = Failure err }, Cmd.none )

        UpdateWeather res ->
            case res of
                Ok weatherInfo ->
                    ( { model | weatherInfo = Success weatherInfo }, Cmd.none )

                Err err ->
                    ( { model | weatherInfo = Failure err }, Cmd.none )

        UpdateInstagram res ->
            case res of
                Ok instagram ->
                    ( { model | instagram = Success instagram }, Cmd.none )

                Err err ->
                    ( { model | instagram = Failure err }, Cmd.none )

        UpdatePublicTransport res ->
            case res of
                Ok publicTransports ->
                    ( { model | publicTransport = Success <| sortWith sortTransport <| List.concat publicTransports }, Cmd.none )

                Err err ->
                    ( { model | publicTransport = Failure err }, Cmd.none )

        UpdateSlackInfo res ->
            case res of
                Ok slackInfo ->
                    ( { model | slackInfo = Success slackInfo }, Cmd.none )

                Err err ->
                    ( { model | slackInfo = Failure err }, Cmd.none )

        UpdateLunchMenu res ->
            case res of
                Ok lunchMenu ->
                    ( { model | lunchMenu = Success lunchMenu }, Cmd.none )

                Err err ->
                    ( { model | lunchMenu = Failure err }, Cmd.none )



-- Url Handling


handleUrlRequest : Key -> UrlRequest -> Cmd Msg
handleUrlRequest key urlRequest =
    case urlRequest of
        Internal url ->
            Nav.pushUrl key (Url.toString url)

        External url ->
            Nav.load url


urlParser : Birthdays -> Parser (Page -> msg) msg
urlParser birthdays =
    UrlParser.oneOf
        [ UrlParser.map Transit <| UrlParser.s "transit"
        , UrlParser.map Slack <| UrlParser.s "slack"
        , UrlParser.map Instagram <| UrlParser.s "instagram"
        , UrlParser.map Weather <| UrlParser.s "weather"
        , UrlParser.map Lunch <| UrlParser.s "lunch"
        , UrlParser.map Calendar <| UrlParser.s "calendar"
        , UrlParser.s "birthday" </> UrlParser.custom "" (birthdayUrlName birthdays)
        ]


birthdayUrlName : Birthdays -> String -> Maybe Page
birthdayUrlName birthdays segment =
    let
        person =
            case birthdays of
                Success birthdays_ ->
                    birthdays_
                        |> List.filter (\b -> b.firstName == segment)
                        |> List.head

                _ ->
                    Nothing
    in
    case person of
        Just person_ ->
            Just (Birthday person_)

        Nothing ->
            Nothing



-- Random


oneToThirty : Random.Generator Int
oneToThirty =
    Random.int 1 30



-- Meda Handling


setMedia : (Media -> Media) -> Model -> Model
setMedia fn model =
    { model | media = fn model.media }


setSlackImgs : List Href -> Media -> Media
setSlackImgs imgs media =
    { media | slackImgs = imgs }


setLunchImgs : List Href -> Media -> Media
setLunchImgs imgs media =
    { media | lunchImgs = imgs }


setDigit : Int -> Media -> Media
setDigit digit media =
    { media | digit = digit }



-- Page handling


nextPage : List Page -> Page -> Page
nextPage pages active =
    pages
        |> ListExtra.elemIndex active
        |> Maybe.map ((+) 1)
        |> Maybe.andThen (\index -> ListExtra.getAt index pages)
        |> Maybe.withDefault (Maybe.withDefault Weather (List.head pages))


updateNow : Posix -> Model -> Model
updateNow now model =
    { model
        | here =
            Here now model.here.zone <|
                toWeekday model.here.zone now
    }


setPages : (Pages -> Pages) -> Model -> Model
setPages fn model =
    { model | pages = fn model.pages }


setActivePage : Page -> Pages -> Pages
setActivePage active pages =
    { pages | active = active }


setPageCountdown : Int -> Pages -> Pages
setPageCountdown countdown pages =
    { pages | countdown = countdown }


setAvailablePages : List Page -> Pages -> Pages
setAvailablePages available pages =
    { pages | available = available }


updateActivePage : Page -> Model -> Model
updateActivePage page =
    setPages <| setActivePage page


updatePageCountdown : Int -> Model -> Model
updatePageCountdown countdown =
    setPages <| setPageCountdown countdown


updateAvailablePages : List Page -> Model -> Model
updateAvailablePages available =
    setPages <| setAvailablePages available