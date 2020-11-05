module Main exposing (main)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Helpers exposing (getPageKey)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Page.Birthday as Birthday
import Page.Calendar as Calendar
import Page.Instagram as Instagram
import Page.Lunch as Lunch
import Page.Slack as Slack
import Page.Surf as Surf
import Page.Traffic as Traffic
import Page.Transit as Transit
import Page.Video as Video
import Page.Weather as Weather
import Task
import Time
import Updates exposing (update, urlParser)
import Url exposing (Url)
import Url.Parser as UrlParser
import Views exposing (viewBackground, viewRemoteData, viewSidebar)



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
subscriptions _ =
    Sub.batch
        [ Time.every 1000 EverySecond
        , Time.every (1000 * 60) EveryMinute
        , Time.every (1000 * 60 * 60) EveryHour
        , Time.every (1000 * 60 * 60 * 24) EveryDay
        ]


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init { apiKey, pageCountdownMillis } url key =
    let
        urlPage =
            Maybe.withDefault Lunch <|
                UrlParser.parse (urlParser NotAsked) url

        model =
            { key = key
            , apiKey = apiKey
            , here = Here (Time.millisToPosix 0) Time.utc Time.Mon
            , pages =
                { active = urlPage
                , countdown = pageCountdownMillis
                , defaultCountdown = pageCountdownMillis
                , available =
                    [ Lunch
                    , Slack
                    , Transit
                    , Weather
                    ]
                }
            , publicTransport = NotAsked
            , weatherInfo = NotAsked
            , birthdays = NotAsked
            , slackInfo = NotAsked
            , slackEvents = NotAsked
            , instagram = NotAsked
            , lunchMenu = NotAsked
            , calendar = NotAsked
            , media =
                { digit = 15
                , slackImgs = []
                , lunchImgs = []
                }
            }
    in
    ( model
    , Cmd.batch
        [ Nav.pushUrl key (getPageKey urlPage)
        , Task.perform SetTimeZone Time.here
        , Task.perform FetchAllData Time.now
        ]
    )



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view model =
    main_ []
        [ viewBackground model
        , div [ class "layout" ]
            [ viewPage model
            , viewSidebar model
            ]
        ]


viewPage : Model -> Html Msg
viewPage model =
    case model.pages.active of
        Transit ->
            viewRemoteData model .publicTransport Transit.view

        Slack ->
            viewRemoteData model .slackEvents Slack.view

        Birthday person ->
            case model.birthdays of
                Success _ ->
                    Birthday.view person

                _ ->
                    div [ style "padding" "5vmax", style "display" "flex" ]
                        [ div [] [ text "⌛" ]
                        , div [] [ text "Laster..." ]
                        ]

        Weather ->
            viewRemoteData model .weatherInfo Weather.view

        Instagram ->
            viewRemoteData model .instagram Instagram.view

        Lunch ->
            viewRemoteData model .lunchMenu Lunch.view

        Calendar ->
            viewRemoteData model .calendar Calendar.view

        Video ->
            viewRemoteData model .publicTransport Video.view

        Traffic ->
            viewRemoteData model .publicTransport Traffic.view

        Surf ->
            viewRemoteData model .weatherInfo Surf.view
