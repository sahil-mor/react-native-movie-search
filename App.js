import React from 'react'
import {createAppContainer} from 'react-navigation'
import {createStackNavigator, HeaderTitle} from 'react-navigation-stack'

import Home from './screens/Home'
import Movie from './screens/Movie'
const mainNavigator = createStackNavigator({
  Home : { screen : Home },
  Movie : { screen : Movie }
},
 {
  defaultNavigationOptions :{
    headerStyle : {
      backgroundColor : "grey"
    },
    headerTitle : "Home of Movies",
    headerTitleStyle : {
      color : "white",
      fontWeight : "bold"
    },
    headerTintColor : "white"
  }
}
)

export default createAppContainer(mainNavigator)