module Page.Transit exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Icons exposing (..)
import Model exposing (..)


view : Model -> Html msg
view model =
    case model.publicTransport of
        Success publicTransport ->
            div [ class "page transit-page" ]
                [  body publicTransport model
                , square model
                ]

        _ ->
            div [ class "page transit-page" ]
                [ div [ class "content" ]
                    [ div [ class "animated fadeInDown faster today" ]
                        [ div [] [ text "Mangler data" ]
                        ]
                    ]
                ]


body : List Transport -> Model -> Html msg
body publicTransport model =
    div [ class "content--box" ]
        [ div [ class "animated fadeInDown faster" ]
            [ div [ class "transit-departures" ] <| List.map (departure model) <|
                    List.take 6 publicTransport,
                     span [class "transit-station-text"][text "Fra Gauselvågen busstopp og Jåttåvågen togstasjon"]
            ]
        ]


departure : Model -> Transport -> Html msg
departure { here } transport =
    div [ class "transit-departure" ] <|
        case transport of
            Unknown ->
                [ text "Ukjent transport" ]

            Bus departure_ ->
                [ div [class "line-tag-wrapper"] [div [ class <| "line-tag " ++ departureColor departure_.name  ] [ text <| "Buss " ++ departure_.name]] 
                , div [class "line-destination"] [ text departure_.destination ]
                , div [class "line-time"] [ text <| formatDateDiffMinutes here.zone here.time departure_.time ]
                ]

            Train departure_ ->
                [ div [class "line-tag-wrapper"] [                    div [ class <| "line-tag " ++ departureColor departure_.name ] [text "Toget"  ]]
                , div [class "line-destination"] [ text departure_.destination ]
                , div [class "line-time"] [ text <| formatDateDiffMinutes here.zone here.time departure_.time ]
                ]

departureColor : String -> String
departureColor lineName =
    case lineName of
        "2" ->
            "line-2"
        "3" ->
            "line-3"
        "6" ->
            "line-6"
        "X31" ->
            "line-x31"
        "Jærbanen" ->
            "line-train"

        _ ->
            "line-unknown"

square : Model -> Html msg
square _ =
    div [ class "square transit-map-wrapper" ]
        [ div [ class "animated fadeIn faster delay-2s transit-map iframe-wrapper" ]
            [ --iframe [ class "", src "https://www.kolumbus.no/ruter/kart/sanntidskart/?c=58.914520,5.732501,14&lf=all&vt=bus,ferry" ] [ text "Loading" ]
             iframe [ class "", src "https://kart.kolumbus.no/?c=58.915463,5.729394,14&lineName=3,2,X31,6,59,50" ] [ text "Loading" ]
            ]
        ]
