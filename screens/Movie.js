import React from 'react'
import {View,Text,StyleSheet,Image,Dimensions,ScrollView} from 'react-native'
import {Accordion,Content, Card, CardItem, Thumbnail,Left, Body, } from 'native-base'

export default class Movie extends React.Component{
    static navigationOptions = {
        title : "Movie"
    }
    constructor(props){
        super(props);
        this.state = {
            movieId : this.props.navigation.getParam("id","no id"),data : null, showData : false,message : "",arrData : []
        }
    }
    componentDidMount(){
        if(this.state.movieId === 'no id'){
            this.props.navigation.goBack()
        }else{
            return fetch("http://www.omdbapi.com/?apikey=ur api key&i=" + this.state.movieId)
            .then(response => {
                let responseJson = response.json()
                .then(responseJSON => {
                    console.log(responseJSON)
                    let rating = ""
                    responseJSON.Ratings.forEach(obj => {
                        rating += obj.Source +  " - " + obj.Value + "\n"
                    });
                    let arr = []
                    if(responseJSON.hasOwnProperty("Plot")){ arr.push({ title : "Plot", content : responseJSON.Plot })}
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
                    this.setState({ data : responseJSON , showData : true , message : "", arrData : arr })
                })
                .catch(err => {
                    this.setState({ showData : false, message : "Unexpected Error Occur" })
                    console.log(err)
                })
            })
            .catch(error => {
                this.setState({ showData : false, message : "Service Not Availale Please Try Again" })
                console.log(error)
            })
        }
    }
    render(){
        return(
            <View style={styles.container}>
                <ScrollView>
                {this.state.showData ?
                    <View style={styles.showData}>
                         <Card style={{ backgroundColor : "black",elevation: 3 }}>
                            <CardItem style={{backgroundColor : "black"}}>
                                <Left>
                                    <Thumbnail source={{ uri : this.state.data.Poster}} />
                                    <Body>
                                        <Text style={styles.plotText}>{this.state.data.Title}</Text>
                                        <Text note style={styles.plotText}>{this.state.data.Year}</Text>
                                    </Body>
                                </Left>
                            </CardItem>
                            <CardItem cardBody>
                                <Image style={{ height: 300, flex: 1 }} source={{ uri : this.state.data.Poster}} />
                            </CardItem>
                        </Card>
                        <Content padder style={{backgroundColor : "white"}}>
                            <Accordion dataArray={this.state.arrData} expanded={0}/>
                        </Content>
                    </View>
                : 
                    <Text style={{color : "white"}}> {this.state.message} </Text>
                }
                <View style={{height : 100}}></View>
                </ScrollView>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container : {
        backgroundColor : "#000",flex : 1
    },
    Image : {
        width : Dimensions.get("screen").width * 0.95, height : Dimensions.get("window").height ,marginLeft : Dimensions.get("screen").width * 0.025
    },
    plot : {
        marginTop : 20
    },
    plotText : {
        color : "white"
    }
})
