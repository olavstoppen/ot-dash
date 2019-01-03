port module Main exposing (background, getPage, httpErrorToString, init, main, toJs, update, view)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Helpers exposing (getPageKey)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import Model exposing (..)
import Page.Birthday as Birthday
import Page.Instagram as Instagram
import Page.Slack as Slack
import Page.Transit as Transit
import Page.Weather as Weather
import Services exposing (fetchDepartures, fetchSlackEvents)
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


init : Int -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        urlPage =
            Maybe.withDefault Birthday <|
                UrlParser.parse urlParser url

        model =
            { key = key
            , serverMessage = ""
            , activePage = getActivePage urlPage
            , pages = List.indexedMap pair staticPages
            , departures =
                [ Bus <| Departure (millisToPosix 123123123) "Kvernevik" "3"
                , Train <| Departure (millisToPosix 5645645645) "Tog til Sandnes" "X76"
                , Bus <| Departure (millisToPosix 234234234) "Buss til Forus" "6"
                , Unknown
                ]
            , weather = []
            , birthdays = []
            , slackInfo = SlackData "" [] []
            , slackEvents = []
            }
    in
    ( model
    , Cmd.batch
        [ Nav.pushUrl key (getPageKey urlPage)
        , fetchSlackEvents UpdateSlackEvents
        ]
    )



-- ---------------------------
-- UPDATE
-- ---------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
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

        ChangePage _ ->
            let
                nextUrlPage =
                    first model.activePage
                        |> (+) 1
                        |> getActivePage_
                        |> second
            in
            ( model, Nav.pushUrl model.key <| getPageKey nextUrlPage )

        TestServer ->
            ( model, fetchDepartures OnServerResponse )

        OnServerResponse res ->
            case res of
                Ok r ->
                    ( { model | serverMessage = r }, Cmd.none )

                Err err ->
                    ( { model | serverMessage = "Error: " ++ httpErrorToString err }, Cmd.none )

        UpdateSlackEvents res ->
            case res of
                Ok events ->
                    ( { model | slackEvents = events }, Cmd.none )

                Err err ->
                    Debug.log
                        (httpErrorToString
                            err
                        )
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


main : Program Int Model Msg
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
    Time.every 30000 ChangePage
