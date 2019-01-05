port module Main exposing (background, getPage, httpErrorToString, init, main, toJs, update, view)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Helpers exposing (getPageKey, sortTransport)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import List exposing (..)
import Model exposing (..)
import Page.Birthday as Birthday
import Page.Instagram as Instagram
import Page.Slack as Slack
import Page.Transit as Transit
import Page.Weather as Weather
import Services exposing (..)
import Task
import Time exposing (..)
import Tuple exposing (..)
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser)


port toJs : String -> Cmd msg


urlParser : Parser (Page -> msg) msg
urlParser =
    UrlParser.oneOf
        [ UrlParser.map Transit <| UrlParser.s "transit"
        , UrlParser.map Slack <| UrlParser.s "slack"
        , UrlParser.map Birthday <| UrlParser.s "birthday"
        , UrlParser.map Instagram <| UrlParser.s "instagram"
        , UrlParser.map Weather <| UrlParser.s "weather"
        ]


staticPages : List Page
staticPages =
    [ Transit
    , Slack
    , Birthday
    , Instagram
    , Weather
    ]


getActivePage : Page -> ( Int, Page )
getActivePage page =
    List.indexedMap pair staticPages
        |> List.filter (\( _, page_ ) -> page == page_)
        |> List.head
        |> Maybe.withDefault ( 0, Transit )


getActivePage_ : Int -> ( Int, Page )
getActivePage_ index =
    List.indexedMap pair staticPages
        |> List.filter (\( index_, _ ) -> index == index_)
        |> List.head
        |> Maybe.withDefault ( 0, Transit )


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        urlPage =
            Maybe.withDefault Birthday <|
                UrlParser.parse urlParser url

        model =
            { key = key
            , apiKey = flags.apiKey
            , zone = Time.utc
            , now = millisToPosix 0
            , pageCountdown = 30000
            , activePage = getActivePage urlPage
            , pages = List.indexedMap pair staticPages
            , publicTransport = []
            , weatherInfo = WeatherInfo (WeatherData (Temperature 0.0 0.0 0.0 0.0) Nothing "" "" "") []
            , birthdays = []
            , slackInfo = SlackInfo []
            , slackEvents = []
            , instagram = []
            }
    in
    ( model
    , Cmd.batch
        [ Nav.pushUrl key (getPageKey urlPage)
        , Task.perform SetTimeZone Time.here
        , Task.perform UpdateNow Time.now
        , fetchSlackEvents UpdateSlackEvents model
        , fetchWeather UpdateWeather model
        , fetchInstagram UpdateInstagram model
        , fetchPublicTransport UpdatePublicTransport model
        , fetchSlackInfo UpdateSlackInfo model
        ]
    )



-- ---------------------------
-- UPDATE
-- ---------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        SetTimeZone zone ->
            ( { model | zone = zone }, Cmd.none )

        OnUrlRequest urlRequest ->
            ( model, handleUrlRequest model.key urlRequest )

        OnUrlChange url ->
            let
                urlPage =
                    Maybe.withDefault (second model.activePage) <| UrlParser.parse urlParser url

                nextPage =
                    getActivePage urlPage
            in
            ( { model | activePage = nextPage }, Cmd.none )

        UpdateNow now ->
            let
                nextPageCountdown =
                    model.pageCountdown - 1

                updatedModel =
                    { model | now = now }
            in
            if nextPageCountdown < 0 then
                let
                    nextUrlPage =
                        first model.activePage
                            |> (+) 1
                            |> getActivePage_
                            |> second
                in
                ( { updatedModel | pageCountdown = 30 }, Nav.pushUrl model.key <| getPageKey nextUrlPage )

            else
                ( { updatedModel | pageCountdown = nextPageCountdown }, Cmd.none )

        UpdateSlackEvents res ->
            case res of
                Ok events ->
                    ( { model | slackEvents = events }, Cmd.none )

                Err err ->
                    Debug.log (Debug.toString err)
                        ( model, Cmd.none )

        UpdateWeather res ->
            case res of
                Ok weatherInfo ->
                    ( { model | weatherInfo = weatherInfo }, Cmd.none )

                Err err ->
                    Debug.log (Debug.toString err)
                        ( model, Cmd.none )

        UpdateInstagram res ->
            case res of
                Ok instagram ->
                    ( { model | instagram = instagram }, Cmd.none )

                Err err ->
                    Debug.log (Debug.toString err)
                        ( model, Cmd.none )

        UpdatePublicTransport res ->
            case res of
                Ok publicTransports ->
                    ( { model | publicTransport = sortWith sortTransport <| List.concat publicTransports }, Cmd.none )

                Err err ->
                    Debug.log (Debug.toString err)
                        ( model, Cmd.none )

        UpdateSlackInfo res ->
            case res of
                Ok slackInfo ->
                    ( { model | slackInfo = slackInfo }, Cmd.none )

                Err err ->
                    Debug.log (Debug.toString err)
                        ( model, Cmd.none )


handleUrlRequest : Key -> UrlRequest -> Cmd Msg
handleUrlRequest key urlRequest =
    case urlRequest of
        Internal url ->
            Nav.pushUrl key (Url.toString url)

        External url ->
            Nav.load url


httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        BadUrl _ ->
            "BadUrl"

        Timeout ->
            "Timeout"

        NetworkError ->
            "NetworkError"

        BadStatus _ ->
            "BadStatus"

        BadBody s ->
            "BadBody: " ++ s



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view model =
    main_ []
        [ background model
        , div [ class "layout" ]
            [ getPage model
            , sidebar model
            ]
        ]


getPage : Model -> Html Msg
getPage model =
    model
        |> (case second model.activePage of
                Transit ->
                    Transit.view

                Slack ->
                    Slack.view

                Birthday ->
                    Birthday.view

                Weather ->
                    Weather.view

                Instagram ->
                    Instagram.view
           )


background : Model -> Html Msg
background model =
    div [ class "background" ]
        [ div [ class "background__page" ] []
        , div [ class "background__divider" ] []
        , div [ class "background__sidebar" ] []
        ]


sidebar : Model -> Html Msg
sidebar model =
    nav [ class "sidebar" ]
        [ a [ href "/slack" ] [ text "Slack" ]
        , a [ href "/weather" ] [ text "Weather" ]
        , a [ href "/transit" ] [ text "Transit" ]
        , a [ href "/instagram" ] [ text "Instagram" ]
        , a [ href "/birthday" ] [ text "Birthday" ]
        ]


link : Page -> String -> String -> Html Msg
link activePage href_ title =
    a [ href href_ ] [ text title ]



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Olavstoppen"
                , body = [ view m ]
                }
        , subscriptions = subscriptions
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChange
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 UpdateNow
