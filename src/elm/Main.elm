module Main exposing (background, getPage, init, link, main, sidebar, subscriptions, view)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Helpers exposing (fullName, getPageKey, getPageTitle, sortTransport)
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
import Updates exposing (update, urlParser)
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
    Sub.batch
        [ every 1000 EverySecond
        , every (1000 * 60) EveryMinute
        , every (1000 * 60 * 60) EveryHour
        , every (1000 * 60 * 60 * 24) EveryDay
        ]


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        urlPage =
            Maybe.withDefault Instagram <|
                UrlParser.parse (urlParser NotAsked) url

        model =
            { key = key
            , apiKey = flags.apiKey
            , here = Here (millisToPosix 0) Time.utc Mon
            , pages =
                { active = urlPage
                , countdown = 30
                , available =
                    [ Transit
                    , Slack
                    , Instagram
                    , Weather
                    , Lunch
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
        [ background model
        , div [ class "layout" ]
            [ getPage model
            , sidebar model
            ]
        ]


getPage : Model -> Html Msg
getPage model =
    case model.pages.active of
        Transit ->
            Transit.view model

        Slack ->
            Slack.view model

        Birthday person ->
            case model.birthdays of
                Success birthdays ->
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
sidebar { pages } =
    nav [ class "sidebar" ] <| List.map (link pages.active) pages.available


link : Page -> Page -> Html Msg
link activePage page =
    let
        url =
            "/" ++ getPageKey page

        title =
            getPageTitle page

        isActive =
            case page of
                Birthday person ->
                    case activePage of
                        Birthday personActive ->
                            fullName person == fullName personActive

                        _ ->
                            activePage == page

                _ ->
                    activePage == page
    in
    if isActive then
        a [ href url, class "active" ]
            [ div [ class "link__title " ] [ text title ]
            , linkFooter
            ]

    else
        a [ href url ] [ div [ class "link__title " ] [ text title ] ]


linkFooter : Html Msg
linkFooter =
    div [ class "link__footer" ]
        [ div [ class "animated slideInLeft link__footer__bit" ] []
        ]
