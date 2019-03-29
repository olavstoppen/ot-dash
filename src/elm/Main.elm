module Main exposing (main)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Helpers exposing (fullName, getPageKey, getPageTitle, sortTransport)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import List exposing (..)
import Model exposing (..)
import Page.Birthday as Birthday
import Page.Calendar as Calendar
import Page.Instagram as Instagram
import Page.Lunch as Lunch
import Page.Slack as Slack
import Page.Transit as Transit
import Page.Video as Video
import Page.Weather as Weather
import Services exposing (..)
import Task
import Time exposing (..)
import Tuple exposing (..)
import Updates exposing (update, urlParser)
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser)
import Views exposing (viewRemoteData)



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
            Maybe.withDefault Lunch <|
                UrlParser.parse (urlParser NotAsked) url

        model =
            { key = key
            , apiKey = flags.apiKey
            , here = Here (millisToPosix 0) Time.utc Mon
            , pages =
                { active = urlPage
                , countdown = defaultCountdown
                , available =
                    [ Lunch
                    , Slack
                    , Instagram
                    , Calendar
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
                Success birthdays ->
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


viewBackground : Model -> Html Msg
viewBackground model =
    div [ class "background" ]
        [ div [ class "background__page" ] []
        , div [ class "background__divider" ] []
        , div [ class "background__sidebar" ] []
        ]


viewSidebar : Model -> Html Msg
viewSidebar { pages } =
    nav [ class "sidebar" ] <| List.map (viewLink pages.active) pages.available


viewLink : Page -> Page -> Html Msg
viewLink activePage page =
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
            , viewLinkFooter
            ]

    else
        a [ href url ] [ div [ class "link__title " ] [ text title ] ]


viewLinkFooter : Html Msg
viewLinkFooter =
    div [ class "link__footer" ]
        [ div [ class "animated slideInLeft link__footer__bit" ] []
        ]
