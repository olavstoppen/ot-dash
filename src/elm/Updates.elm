module Updates exposing (update, urlParser)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Helpers exposing (fromResult, getPageKey, sortTransport)
import Http exposing (Error(..))
import List
import List.Extra as ListExtra
import Model exposing (Birthdays, Here, Href, Media, Model, Msg(..), Page(..), Pages, RemoteData(..))
import Random
import Services exposing (fetchBirthdays, fetchCalendar, fetchInstagram, fetchLunchImgs, fetchLunchMenu, fetchPublicTransport, fetchSlackEvents, fetchSlackImgs, fetchSlackInfo, fetchWeather)
import Time exposing (Posix, toWeekday)
import Url
import Url.Parser as UrlParser exposing ((</>), Parser)
import Model exposing (Person)



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
                { pages, birthdays } =
                    model

                urlPage =
                    Maybe.withDefault pages.active <|
                        UrlParser.parse (urlParser birthdays) url
            in
            ( updateActivePage urlPage model
                |> updatePageCountdown pages.defaultCountdown
            , Cmd.none
            )

        EverySecond now ->
            let
                updatedModel =
                    updateNow now model

                { pages } =
                    updatedModel

                nextCountdown =
                    calculateNextCountdown model
            in
            if nextCountdown < 0 then
                ( updatePageCountdown model.pages.defaultCountdown updatedModel
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
            ( { model
                | publicTransport = Loading
                , weatherInfo = Loading
                , birthdays = Loading
                , slackInfo = Loading
                , slackEvents = Loading
                , instagram = Loading
                , lunchMenu = Loading
                , calendar = Loading
              }
            , Cmd.batch
                [ fetchSlackEvents UpdateSlackEvents model
                , fetchWeather UpdateWeather model
                , fetchInstagram UpdateInstagram model
                , fetchPublicTransport UpdatePublicTransport model
                , fetchSlackInfo UpdateSlackInfo model
                , fetchLunchMenu UpdateLunchMenu model
                , fetchBirthdays UpdateBirthdays model
                , fetchCalendar UpdateCalendar model
                , fetchSlackImgs UpdateSlackImgs
                , fetchLunchImgs UpdateLunchImgs
                , Random.generate UpdateMediaDigit oneToThirty
                ]
            )

        UpdateMediaDigit digit ->
            ( (setMedia <| setDigit digit) model, Cmd.none )

        UpdateSlackImgs res ->
            case res of
                Ok slackImgs ->
                    ( (setMedia <| setSlackImgs slackImgs) model, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        UpdateLunchImgs res ->
            case res of
                Ok lunchImgs ->
                    ( (setMedia <| setLunchImgs lunchImgs) model, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        UpdateCalendar res ->
            ( { model | calendar = fromResult res }, Cmd.none )

        UpdateBirthdays res ->
            case res of
                Ok birthdays ->
                    let
                        birthdaysMock =  
                            [Person "Firsten-Andresen" "Lastestad" ""]
                        updatedAvailable =
                            List.map Birthday birthdays
                                |> List.append model.pages.available
                    in
                    ( { model | birthdays = Success birthdays }
                        |> updateAvailablePages updatedAvailable
                    , Cmd.none
                    )

                Err err ->
                    ( { model | birthdays = Failure err }, Cmd.none )

        UpdateSlackEvents res ->
            ( { model | slackEvents = fromResult res }, Cmd.none )

        UpdateWeather res ->
            ( { model | weatherInfo = fromResult res }, Cmd.none )

        UpdateInstagram res ->
            ( { model | instagram = fromResult res }, Cmd.none )

        UpdatePublicTransport res ->
            case res of
                Ok publicTransports ->
                    ( { model | publicTransport = Success <| List.sortWith sortTransport <| List.concat publicTransports }, Cmd.none )

                Err err ->
                    ( { model | publicTransport = Failure err }, Cmd.none )

        UpdateSlackInfo res ->
            ( { model | slackInfo = fromResult res }, Cmd.none )

        UpdateLunchMenu res ->
            ( { model | lunchMenu = fromResult res }, Cmd.none )



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
        , UrlParser.map Video <| UrlParser.s "video"
        , UrlParser.map Traffic <| UrlParser.s "traffic"
        , UrlParser.map Surf <| UrlParser.s "surf"
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
    Maybe.map Birthday person



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


calculateNextCountdown : Model -> Int
calculateNextCountdown { pages, here } =
    let
        hour =
            Time.toHour here.zone here.time
    in
    case pages.active of
        Lunch ->
            if hour > 10 && hour < 12 then
                pages.countdown

            else
                pages.countdown - 1

        _ ->
            pages.countdown - 1
