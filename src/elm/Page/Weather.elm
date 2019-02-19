module Page.Weather exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Icons exposing (..)
import Model exposing (..)
import String exposing (..)


view : Model -> Html Msg
view model =
    case model.weatherInfo of
        Success weatherInfo ->
            div [ class "page page__weather" ]
                [ annotation
                , body weatherInfo.today
                , footer weatherInfo.forecast
                ]

        _ ->
            div [ class "page page__weather" ]
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
body weatherData =
    let
        { temperature, symbolUrl, description, rainfall } =
            weatherData

        todayTemp =
            (temperature.current |> fromFloat) ++ " °"

        ( highTemp, lowTemp ) =
            ( viewFloat "Dag " temperature.high " ° ↑"
            , viewFloat "Natt " temperature.low " ° ↓"
            )

        todayRainfall =
            case rainfall of
                Nothing ->
                    div [ class "title" ] [ text "Ingen regn idag! " ]

                Just rainfall_ ->
                    div []
                        [ div [ class "title" ] [ text "Nedbør" ]
                        , div [ class "downfall" ]
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
    in
    div [ class "content--wide" ]
        [ div [ class "animated fadeInDown faster today" ]
            [ div [ class "temperature" ]
                [ div [ class "text--large todays" ] [ text todayTemp ]
                , div [] [ img [ src symbolUrl ] [] ]
                ]
            , div [ class "description" ] [ text description ]
            , div [ class "highlow" ]
                [ div [] [ text highTemp ]
                , div [] [ text lowTemp ]
                ]
            , div [ class "rainfall" ]
                [ todayRainfall
                ]
            ]
        ]


footer : List WeatherData -> Html Msg
footer forecasts =
    div [ class "footer--tall animated fadeIn faster" ]
        [ div [ class "forecasts" ] <|
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
    div [ class "forecast" ]
        [ div [ class "symbol" ] [ img [ src symbolUrl ] [] ]
        , div [ class "temperature text--small" ]
            [ div [] [ text highTemp ]
            , div [ class "fade-out" ] [ text lowTemp ]
            ]
        , div [ class "day text--small" ] [ text day ]
        ]


viewFloat : String -> Float -> String -> String
viewFloat before temp after =
    before ++ (temp |> fromFloat) ++ after
