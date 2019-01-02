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
import Services exposing (fetchDepartures)
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser)



-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : String -> Cmd msg



-- ---------------------------
-- MODEL
-- ---------------------------


init : Int -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    ( initModel flags url key, fetchDepartures OnServerResponse )



-- ---------------------------
-- UPDATE
-- ---------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        OnUrlRequest urlRequest ->
            ( model, handleUrlRequest model.key urlRequest )

        OnUrlChange url ->
            ( { model
                | activePage = Maybe.withDefault model.activePage <| UrlParser.parse urlParser url
              }
            , Cmd.none
            )

        TestServer ->
            ( model, fetchDepartures OnServerResponse )

        OnServerResponse res ->
            case res of
                Ok r ->
                    ( { model | serverMessage = r }, Cmd.none )

                Err err ->
                    ( { model | serverMessage = "Error: " ++ httpErrorToString err }, Cmd.none )


handleUrlRequest : Key -> UrlRequest -> Cmd msg
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
        |> (case model.activePage of
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
    Sub.none
