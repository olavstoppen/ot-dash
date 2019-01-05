module Icons exposing (busIcon, chatIcon, likeIcon, metIcon, trainIcon)

import Svg exposing (path, polyline, svg)
import Svg.Attributes exposing (class, d, fill, height, points, viewBox, width)


busIcon =
    svg [ class "icon--med", width "28", height "32", viewBox "0 0 28 32" ] [ path [ d "M24 15.3594V7H4V15.3594H24ZM19.7031 24.6562C20.1719 25.125 20.7708 25.3594 21.5 25.3594C22.2292 25.3594 22.8281 25.125 23.2969 24.6562C23.7656 24.1354 24 23.5365 24 22.8594C24 22.1823 23.7656 21.6094 23.2969 21.1406C22.8281 20.6198 22.2292 20.3594 21.5 20.3594C20.7708 20.3594 20.1719 20.6198 19.7031 21.1406C19.2344 21.6094 19 22.1823 19 22.8594C19 23.5365 19.2344 24.1354 19.7031 24.6562ZM4.70312 24.6562C5.17188 25.125 5.77083 25.3594 6.5 25.3594C7.22917 25.3594 7.82812 25.125 8.29688 24.6562C8.76562 24.1354 9 23.5365 9 22.8594C9 22.1823 8.76562 21.6094 8.29688 21.1406C7.82812 20.6198 7.22917 20.3594 6.5 20.3594C5.77083 20.3594 5.17188 20.6198 4.70312 21.1406C4.23438 21.6094 4 22.1823 4 22.8594C4 23.5365 4.23438 24.1354 4.70312 24.6562ZM0.640625 23.6406V7C0.640625 4.34375 1.78646 2.57292 4.07812 1.6875C6.36979 0.802083 9.67708 0.359375 14 0.359375C18.3229 0.359375 21.6302 0.802083 23.9219 1.6875C26.2135 2.57292 27.3594 4.34375 27.3594 7V23.6406C27.3594 25.099 26.7865 26.349 25.6406 27.3906V30.3594C25.6406 30.8281 25.4844 31.2188 25.1719 31.5312C24.8594 31.8438 24.4688 32 24 32H22.3594C21.8906 32 21.474 31.8438 21.1094 31.5312C20.7969 31.2188 20.6406 30.8281 20.6406 30.3594V28.6406H7.35938V30.3594C7.35938 30.8281 7.17708 31.2188 6.8125 31.5312C6.5 31.8438 6.10938 32 5.64062 32H4C3.53125 32 3.14062 31.8438 2.82812 31.5312C2.51562 31.2188 2.35938 30.8281 2.35938 30.3594V27.3906C1.21354 26.349 0.640625 25.099 0.640625 23.6406Z" ] [] ]


trainIcon =
    svg [ class "icon", width "28", height "32", viewBox "0 0 560 560" ]
        [ path [ d "M517.8,486.8H37.2c-9.9,0-17.9-8-17.9-17.9c0-9.9,8-17.9,17.9-17.9h480.6c9.9,0,17.9,8,17.9,17.9C535.7,478.8,527.7,486.8,517.8,486.8z" ] []
        , path [ d "M537.1,325c-15.3-45.4-50.6-106.1-50.6-106.1c-15.3-28.3-50.3-28.7-50.3-28.7H287.3l28.2-19.6c7.9-5.5,12.5-13.8,12.5-22.7c0-9-4.6-17.3-12.5-22.7l-70.1-48.7c-8.1-5.7-19.2-3.7-24.9,4.5c-5.6,8.1-3.6,19.2,4.5,24.9l60.5,42.1l-59.5,42.3c0,0-180.5-0.1-181.5,0c-14.6,0.7-24.9,13.2-24.9,27.6v158.1c0,15.4,12.5,27.9,27.9,27.9c0,0,418.2,0.2,438.1,0.2c23.1,0,38-15.6,38-15.6C551.2,364.8,537.1,325,537.1,325z M136.9,268.5c0,5.2-4.3,9.5-9.5,9.5h-5.9H56.8c-5.2,0-9.5-4.3-9.5-9.5v-32.8c0-5.2,4.3-9.5,9.5-9.5h64.6h5.9c5.2,0,9.5,4.3,9.5,9.5V268.5z M252.1,268.5c0,5.2-4.3,9.5-9.5,9.5H172c-5.2,0-9.5-4.3-9.5-9.5v-32.8c0-5.2,4.3-9.5,9.5-9.5h70.5c5.2,0,9.5,4.3,9.5,9.5V268.5z M469,278.1h-86.3c-5.4,0-9.9-4.4-9.9-9.9v-32c0-5.4,4.4-9.9,9.9-9.9h63.5c5.4,0,11.6,4.1,13.8,9l14.9,33.7C477.1,274,474.4,278.1,469,278.1z" ] []
        ]


likeIcon =
    svg [ class "icon--med", width "40", height "44", viewBox "0 0 44 40" ] [ path [ d "M42.9503 11.9276C42.3223 5.01562 37.4299 0.000827405 31.3073 0.000827405C27.2283 0.000827405 23.4934 2.19588 21.3919 5.71393C19.3093 2.15038 15.7276 -2.05155e-08 11.7139 -2.05155e-08C5.59211 -2.05155e-08 0.698946 5.01479 0.0717868 11.9268C0.0221436 12.2321 -0.181393 13.8389 0.437492 16.4592C1.32941 20.2387 3.38961 23.6765 6.39385 26.3986L21.382 40L36.6274 26.3994C39.6316 23.6765 41.6918 20.2395 42.5837 16.4592C43.2026 13.8397 42.9991 12.2329 42.9503 11.9276ZM13.2372 6.68363C9.58756 6.68363 6.61807 9.65312 6.61807 13.3027C6.61807 13.7603 6.24823 14.1301 5.79068 14.1301C5.33314 14.1301 4.9633 13.7603 4.9633 13.3027C4.9633 8.74051 8.67495 5.02885 13.2372 5.02885C13.6947 5.02885 14.0645 5.3987 14.0645 5.85624C14.0645 6.31379 13.6939 6.68363 13.2372 6.68363Z" ] [] ]


chatIcon =
    svg [ class "icon--med", width "40", height "40", viewBox "0 0 40 40" ] [ path [ d "M20.3329 0C9.4882 0 0.666197 8.822 0.666197 19.6667C0.666197 23.098 1.56353 26.4687 3.26353 29.4333L0.0341968 39.1227C-0.0431365 39.3553 0.0128635 39.6107 0.180197 39.7893C0.30753 39.9253 0.484197 40 0.666197 40C0.722863 40 0.77953 39.9927 0.836197 39.978L11.4135 37.194C14.1615 38.5947 17.2389 39.3333 20.3329 39.3333C31.1769 39.3333 39.9995 30.5113 39.9995 19.6667C39.9995 8.822 31.1769 0 20.3329 0ZM33.7029 12.6967C33.6009 12.752 33.4909 12.7787 33.3829 12.7787C33.1469 12.7787 32.9195 12.6533 32.7975 12.4327C30.4729 8.196 26.0509 5.21867 21.2562 4.662C20.8902 4.62 20.6289 4.28867 20.6709 3.92333C20.7129 3.55867 21.0422 3.29467 21.4095 3.338C26.6262 3.94333 31.4375 7.18267 33.9662 11.792C34.1435 12.1147 34.0249 12.52 33.7029 12.6967Z" ] [] ]


metIcon =
    svg [ class "icon--med met-icon-fix", width "61", height "71", viewBox "0 0 41 51", fill "#0090A8" ]
        [ path
            [ d "M15.6423009,3.12228084 C8.46654867,3.12228084 2.62902655,8.95908929 2.62902655,16.1323864 C2.62902655,23.307276 8.46654867,29.1431997 15.6423009,29.1431997 C22.819823,29.1431997 28.6587611,23.307276 28.6587611,16.1323864 C28.6587611,8.95908929 22.819823,3.12228084 15.6423009,3.12228084 L15.6423009,3.12228084 Z M15.6423009,31.4470633 C7.19876106,31.4470633 0.327964602,24.5754627 0.327964602,16.1323864 C0.327964602,7.6909026 7.19876106,0.820186688 15.6423009,0.820186688 C24.0883186,0.820186688 30.9584071,7.6909026 30.9584071,16.1323864 C30.9584071,24.5754627 24.0883186,31.4470633 15.6423009,31.4470633 L15.6423009,31.4470633 Z"
            ]
            []
        , polyline [ points "24.7819469 50.8858685 18.7895575 44.8975925 12.7961062 50.8858685 6.80230088 44.8975925 1.56283186 50.1326006 0.0561061947 48.6280114 6.80230088 41.888237 12.7961062 47.8738588 18.7895575 41.888237 24.780177 47.8738588 30.0132743 42.6388506 31.5212389 44.146625 24.7819469 50.8858685" ] []
        ]
