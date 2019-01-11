module Main exposing (background, getPage, init, link, main, sidebar, subscriptions, view)

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
import Page.Error as Error
import Page.Instagram as Instagram
import Page.Lunch as Lunch
import Page.Slack as Slack
import Page.Transit as Transit
import Page.Weather as Weather
import Services exposing (..)
import Task
import Time exposing (..)
import Tuple exposing (..)
import Updates exposing (getActivePage, pages, update, urlParser)
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser)



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


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        urlPage =
            Maybe.withDefault Instagram <|
                UrlParser.parse urlParser url

        model =
            { key = key
            , apiKey = flags.apiKey
            , here = Here (millisToPosix 0) Time.utc Mon
            , pageCountdown = 30000
            , activePage = getActivePage urlPage
            , pages = pages
            , publicTransport = NotAsked
            , weatherInfo = NotAsked
            , birthdays = NotAsked
            , slackInfo = NotAsked
            , slackEvents = NotAsked
            , instagram = NotAsked
            , lunchMenu = NotAsked
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
        , fetchLunchMenu UpdateLunchMenu model
        ]
    )



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
    case second model.activePage of
        Transit ->
            Transit.view model

        Slack ->
            Slack.view model

        Birthday ->
            case model.birthdays of
                Success birthdays ->
                    case List.head birthdays of
                        Nothing ->
                            div [] []

                        Just person ->
                            Birthday.view person

                Failure err ->
                    Error.view err

                _ ->
                    div [] [ text "loading" ]

        Weather ->
            Weather.view model

        Instagram ->
            Instagram.view model

        Lunch ->
            Lunch.view model


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
        , a [ href "/lunch" ] [ text "Lunsjmeny" ]
        ]


link : Page -> Page -> String -> String -> Html Msg
link activePage page href_ title =
    a [ classList [ ( "page", activePage == page ) ], href href_ ] [ text title ]
