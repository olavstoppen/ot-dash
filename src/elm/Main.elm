port module Main exposing (add1, main, toJs, update, view)

import Browser
import Browser.Navigation as Nav
import Helpers exposing (getPageKey)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import Model exposing (..)
import Page.Slack as Slack
import Page.Transit as Transit
import Services exposing (fetchDepartures)



-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : String -> Cmd msg



-- ---------------------------
-- MODEL
-- ---------------------------


init : Int -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, fetchDepartures OnServerResponse )



-- ---------------------------
-- UPDATE
-- ---------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Inc ->
            ( add1 model, toJs "Hello hm" )

        TestServer ->
            ( model, fetchDepartures OnServerResponse )

        OnServerResponse res ->
            case res of
                Ok r ->
                    ( { model | serverMessage = r }, Cmd.none )

                Err err ->
                    ( { model | serverMessage = "Error: " ++ httpErrorToString err }, Cmd.none )


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


{-| increments the counter

    add1 5 --> 6

-}
add1 : Model -> Model
add1 model =
    { model | counter = model.counter + 1 }



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view model =
    main_ []
        [ background model
        , getPage model
        ]


getPage : Model -> Html Msg
getPage model =
    model
        |> (case model.page of
                Transit ->
                    Transit.view

                Slack ->
                    Slack.view

                Birthday ->
                    Transit.view
           )


background : Model -> Html Msg
background model =
    div [ class "background" ]
        [ div [ class "background__page" ] []
        , div [ class "background__divider" ] []
        , sidebar model
        ]


sidebar : Model -> Html Msg
sidebar model =
    nav [ class "sidebar" ]
        [ a [] [ text "Slack" ]
        , a [] [ text "Weather" ]
        , a [ class "active" ] [ text "Transit" ]
        , a [] [ text "Instagram" ]
        , a [] [ text "Birthday" ]
        ]



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program Int Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Olavstoppen"
                , body = [ view m ]
                }
        , subscriptions = \_ -> Sub.none
        }
