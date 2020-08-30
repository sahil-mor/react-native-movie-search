import React, { useState } from 'react';
import {View,Text,StyleSheet,Image, TouchableOpacity, ScrollView, Dimensions, ActivityIndicator,
ImageBackground, TextInput } from 'react-native'


import {Accordion,Content } from 'native-base'

import Carousel from 'react-native-anchor-carousel'

import { Feather, MaterialIcons} from '@expo/vector-icons'


const {width,height} = Dimensions.get("window")


const Home = () => {
    const[ movieName,setMovieName] = useState(null); 
    const [wait,setWait] = useState(false)
    const [movieId,setMovieId] = useState(null)
    const[apikey,setApiKey] = useState("")
    const[ carouselRef] = useState(null)
    const [arrData,setArrData] = useState(null)
    const [message,setMessage] = useState("Search Your Movies Here")
    const [bgImg,setBgImg] = useState("https://m.media-amazon.com/images/M/MV5BNDYxNjQyMjAtNTdiOS00NGYwLWFmNTAtNThmYjU5ZGI2YTI1XkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg")
    const [background,setBackground] = useState(null)
      const [gallery,setGallery] = useState(null)
      const renderItem = (item,index) => {
        return(
            <View>
                <TouchableOpacity 
                onPress={() => {
                  setMovieId(item.item.imdbID)
                  searchMovie(item.item.imdbID)
                }}
                >
                    <Image source={{uri : item.item.Poster}} style={styles.carouselImage} />
                    <Text style={styles.carouselText}> {item.item.Title} </Text>
                </TouchableOpacity>
            </View>
        )
      }
      const searchMovie = (movieIdd) => {
        if(movieIdd === null){
          alert("no id")
        }else{
            return fetch("http://www.omdbapi.com/?apikey=" + apikey + "&i=" + movieIdd)
            .then(response => {
                let responseJson = response.json()
                .then(responseJSON => {
                    let rating = ""
                    responseJSON.Ratings.forEach(obj => {
                        rating += obj.Source +  " - " + obj.Value + "\n"
                    });
                    let arr = []
                    if(responseJSON.hasOwnProperty("Released")){ arr.push({ title : "Released", content : responseJSON.Released })  }
                    if(responseJSON.hasOwnProperty("Runtime")){ arr.push({ title : "Runtime" , content : responseJSON.Runtime }) }
                    if(responseJSON.hasOwnProperty("Genre")){ arr.push({ title : "Genre" , content : responseJSON.Genre }) }
                    if(responseJSON.hasOwnProperty("Director")){ arr.push( { title : "Director", content : responseJSON.Director}) }
                    if(responseJSON.hasOwnProperty("Writer")){ arr.push({ title : "Writer",content : responseJSON.Writer }) }
                    if(responseJSON.hasOwnProperty("Actors")){ arr.push( { title : "Actors", content : responseJSON.Actors }) }
                    if(responseJSON.hasOwnProperty("Language")){ arr.push({ title : "Language", content : responseJSON.Language }) }
                    if(responseJSON.hasOwnProperty("Country")){ arr.push( { title : "Country", content : responseJSON.Country }) }
                    if(responseJSON.hasOwnProperty("Awards")){ arr.push( { title : "Awards",content : responseJSON.Awards }) }
                    if(responseJSON.hasOwnProperty("Ratings")){ arr.push({ title : "Ratings", content : rating }) }
                    setBackground(responseJSON)
                    setArrData(arr)
                    setBgImg(responseJSON.Poster)
                    setMessage(responseJSON.Title)
                })
                .catch(err => {
                    alert("error")
                    console.log(err)
                })
            })
            .catch(error => {
                alert("errorr")
                console.log(error)
            })
        }
      }
      const searchForMovie = () => {
        setWait(true)
        console.log("please wait")
        if(movieName === ""){
          alert("Enter Something To Search")
        }else{
          return fetch("http://www.omdbapi.com/?apikey=" + apikey + "&s=" + movieName)
          .then(response => {
            setWait(false)
            let responseJson = response.json()
            .then((responseJson)=>{
              console.log("here",responseJson.Response)
              if(responseJson.Response == "False"){
                setBackground(null)
                setMessage("No Movie Found")
                return
              }
              setGallery(responseJson.Search)
            })
            .catch(err => console.log(err))
          })
          .catch( error => {
            setWait(false)
            alert("error")
            console.log(error + "  in catch")
          } )
        }
      }
      // if(wait){
      //   return(
      //     <ActivityIndicator size="large" color="#00ff00" />
      //   )
      // }
    return (
      <ScrollView>
      <View style={styles.carouselContentContainer}>
          <View style={{...StyleSheet.absoluteFill,backgroundColor : '#000' }}>
              <ImageBackground
                  source={{uri : bgImg}}
                  style = {styles.imageBg}
                  blurRadius = {10}
              >
                {wait ? 
                <View style={{flex:1,marginTop : height/2 ,alignItems : "center"}}>
                  <Text style={styles.movieName}> Please Wait </Text>
                  <ActivityIndicator size="large" color="#00ff00" />
                </View> : 
              <View>
              <View style={styles.searchBoxContainer}>
                  <TextInput 
                      placeholder="Search Movies"
                      placeholderTextColor = "#666"
                      style={styles.searchBox}
                      onChangeText = { movieName => {
                        setMovieName(movieName)
                      } }
                  />
                  <Feather onPress={()=>{searchForMovie()}} name="search" size={22} color="#666" style={styles.searchBoxIcon} />
              </View>
              <Text style={{color : "white",fontSize : 24,fontWeight : "bold",
              marginLeft : 10,marginVertical : 10}}> {message} </Text>
              <View style={styles.carouselContainerView}>
                  <Carousel 
                      data = {gallery}
                      renderItem={renderItem}
                      itemWidth={200}
                      containerWidth={ width - 20 }
                      separatorWidth={0}
                      ref={carouselRef}
                      inActiveOpacity={0.4}
                  />
              </View>
              {background == null ? <View /> : 
                  <View style={styles.movieInfoContainer}>
                      <View style={{justifyContent : "center"}}>
                        <Text style={styles.movieName}> {background.Title} ({background.Runtime}) </Text>
                        <View style={{paddingHorizontal : 14,marginTop : 14}} >
                          <Text style={{color : "white",opacity : 0.8,lineHeight : 20}} > {background.Plot} </Text>
                        </View>
                        <View style={{marginTop : 30, backgroundColor : "#000"}}>
                          <Accordion backgroundColor="#000" dataArray={arrData} expanded={0}/>
                        </View>   
                      </View>
                  </View>
                  
                }
                </View>
              }
              </ImageBackground>
          </View>
        
      </View>
      
  </ScrollView>

    );
  }

const styles = new StyleSheet.create({
  carouselContentContainer : {
      flex : 1,
      backgroundColor : "#000",
      height : height + 450 ,
      paddingHorizontal : 14
  },
  imageBg : {
      flex : 1,
      height : null,
      width : null,
      opacity : 1,
      justifyContent : "flex-start"
  },
  searchBoxContainer : {
      backgroundColor : "#fff",
      elevation : 10,
      borderRadius : 4,
      marginVertical : 35,
      width : "95%",
      flexDirection : "row",
      alignSelf : "center"
  },
  searchBox : {
      padding : 12,
      paddingLeft : 20,
      fontSize : 16
  },
  searchBoxIcon : {
      position : "absolute",
      right : 20,
      top : 14
  },
  carouselContainerView : {
      width : "100%",
      height : 350,
      justifyContent : "center",
      alignItems: "center"
  },
  Carousel : {
      flex : 1,
      overflow : "visible"
  },  
  carouselImage : {
      width : 200,
      height : 320,
      borderRadius : 10,
      alignSelf : "center",
      backgroundColor : "rgba(0,0,0,0.9)"
  },
  carouselText:{
      padding : 14,
      color : "white",
      position : "absolute",
      bottom : 10,
      left : 2,
      fontWeight : "bold"
  },
  movieInfoContainer : {
      flexDirection : "row",
      marginTop : 16,
      justifyContent : "space-between",
      width : "100%"
  },
  movieName : {
      paddingLeft : 14,
      color : "white",
      fontWeight : "bold",
      fontSize : 20,
      marginBottom : 6
  },
  movieStat : {
      paddingLeft : 14,
      color : "white",
      fontWeight : "bold",
      fontSize : 14,
      opacity : 0.8
  },
});


export default Home