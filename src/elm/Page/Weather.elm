module Page.Weather exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Icons exposing (metIcon)
import Model exposing (..)
import String exposing (..)


view : Model -> Html Msg
view model =
    case model.weatherInfo of
        Success weatherInfo ->
            div [ class "page weather-page" ]
                [ annotation
                , body weatherInfo.today
                , footer weatherInfo.forecast
                ]

        _ ->
            div [ class "page weather-page" ]
                [ div [ class "content--wide" ]
                    [ div [ class "animated fadeInDown faster today" ]
                        [ div [ class "description" ] [ text "Venter på været... ☘️" ]
                        ]
                    ]
                ]


annotation : Html Msg
annotation =
    div [ class "annotation animated fadeIn faster" ]
        [ metIcon
        , h3 [] [ text "met.no" ]
        ]


body : WeatherData -> Html Msg
body { temperature, symbolUrl, description, rainfall } =
    let
        todayTemp =
            (temperature.current |> fromFloat) ++ " °"

        ( highTemp, lowTemp ) =
            ( viewFloat "Dag " temperature.high " ° ↑"
            , viewFloat "Natt " temperature.low " ° ↓"
            )
    in
    div [ class "content--wide" ]
        [ div [ class "animated fadeInDown faster weather-today" ]
            [ div [ class "today-status" ]
                [ div [ class "text--large today-temperature" ] [ text todayTemp ]
                , div [] [ img [ src symbolUrl ] [] ]
                ]
            , div [ class "today-description" ] [ text description ]
            , div [ class "today-highlow" ]
                [ div [] [ text highTemp ]
                , div [] [ text lowTemp ]
                ]
            , div [ class "today-rainfall" ]
                [ todayRainfall rainfall
                ]
            ]
        ]


todayRainfall : Maybe Rainfall -> Html msg
todayRainfall rainfall =
    case rainfall of
        Nothing ->
            div [ class "rainfall-title" ] [ text "Ingen regn idag! " ]

        Just rainfall_ ->
            div []
                [ div [ class "rainfall-title" ] [ text "Nedbør" ]
                , div [ class "rainfall-downfall" ]
                    [ div []
                        [ text <|
                            viewFloat "Høy " rainfall_.high " mm"
                        ]
                    , div []
                        [ text <|
                            viewFloat "Lav " rainfall_.low " mm"
                        ]
                    ]
                ]


footer : List WeatherData -> Html Msg
footer forecasts =
    div [ class "footer--tall animated fadeIn faster" ]
        [ div [ class "weather-forecasts" ] <|
            List.map forecast forecasts
        ]


forecast : WeatherData -> Html Msg
forecast { symbolUrl, temperature, day } =
    let
        ( highTemp, lowTemp ) =
            ( viewFloat "" temperature.high " ° ↑"
            , viewFloat "" temperature.low " ° ↓"
            )
    in
    div [ class "weather-forecast" ]
        [ div [ class "forecast-symbol" ] [ img [ src symbolUrl ] [] ]
        , div [ class "forecast-temperature text--small" ]
            [ div [] [ text highTemp ]
            , div [ class "fade-out" ] [ text lowTemp ]
            ]
        , div [ class "forecast-day text--small" ] [ text day ]
        ]


viewFloat : String -> Float -> String -> String
viewFloat before temp after =
    before ++ (temp |> fromFloat) ++ after
