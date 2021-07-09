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
                [ {-annotation
                ,-} body weatherInfo.today
                , footer weatherInfo.forecast
                ]

        _ ->
            div [ class "page weather-page" ]
                [ div [ class "weather-content" ]
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
            (temperature.current |> fromFloat) ++ " °C"

        ( minMaxTemp ) =
            ( viewFloat "Temperatur: " temperature.low " °C - " ++ viewFloat "" temperature.high " °C"
            )
    in
    div [ class "weather-content" ]
        [ div [ class "animated fadeInDown faster weather-today" ]
            [ div [ class "today-status" ]
                [ div [ class "today-temperature" ] [ text todayTemp], div [ class "today-highlow" ]
                [ div [class "today-details"] [ span [] [ text minMaxTemp ], todayRainfall rainfall  ],
                div [ class "today-description" ] [ text description ] ]
                 {-,div [] [ img [ src symbolUrl ] [] ]-}
                ]
            ]
        ]


todayRainfall : Maybe Rainfall -> Html Msg
todayRainfall rainfall =
    case rainfall of
        Nothing ->
             span [ ] [ text "Nedbør: 0 mm"]

        Just rainfall_ ->
                span [ ] [ text <|
                            viewFloat "Nedbør: " rainfall_.low " - " ++
                            viewFloat "" rainfall_.high " mm" 
                            ]



footer : List WeatherData -> Html Msg
footer forecasts =
    div [ class "weather-footer animated fadeIn faster" ]
        [ div [ class "weather-forecasts" ] <|
            List.map forecast forecasts
        ]


forecast : WeatherData -> Html Msg
forecast { symbolUrl, temperature, day } =
    let
        ( temp ) =
            ( viewFloat "" temperature.current " °C"
            )
    in
    div [ class "weather-forecast" ]
        [
        div [ class "forecast-day" ] [ text day ],
        div [ class "forecast-temperature" ][ div [] [ text temp ]],
        div [ class "forecast-symbol" ] [ img [ src symbolUrl ] [] ]
        ]


viewFloat : String -> Float -> String -> String
viewFloat before temp after =
    before ++ (temp |> fromFloat) ++ after
