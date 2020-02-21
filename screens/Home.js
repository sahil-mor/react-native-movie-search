import React from 'react';
import { StyleSheet, Text, View,TouchableWithoutFeedback,Keyboard,ScrollView,FlatList,TouchableOpacity,Dimensions} from 'react-native';
import {Form,Item,Input,Button,Label,Card,CardItemContainer, Header, Content, List, ListItem,CardItem ,Left, Body, Right, Thumbnail,} from "native-base"
import {AntDesign} from '@expo/vector-icons'
export default class Home extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      data : null,showData : false,movieName : "",message : "",apikey : "a07e5bfb"
    }
  }
  searchForMovie = () => {
    if(this.state.movieName === ""){
      this.setState({ showData : false , message : "Enter A Movie Name First" })
    }else{
      return fetch("http://www.omdbapi.com/?apikey=ur api key&s=" + this.state.movieName)
      .then(response => {
        let responseJson = response.json()
        .then((responseJson)=>{
          console.log(responseJson)
            this.setState({ showData : true , message : "",data : responseJson })
        })
        .catch(err => console.log(err))
      })
      .catch( error => {
        this.setState({ showData : false, message : "Unexpected Error Occured Please Try Again!!!" })
        console.log(error + "  in catch")
      } )
    }
  }
  render(){
    return (
      <TouchableWithoutFeedback onPress={()=>{Keyboard.dismiss()}}>
          <View style={styles.container}>
          <ScrollView>
            <View style={styles.form}>
              <Form>
                <Item>
                  <Label style={styles.label}>Search</Label>
                  <Input style={styles.input} onChangeText={(value)=>{ this.setState({ movieName : value }) }} />
                  <Button rounded warning style={styles.button} onPress={()=>{this.searchForMovie()}}>
                    <Text style={styles.btnText}>Search</Text>
                  </Button>
                </Item>
              </Form>
            </View>
            <View>
              {this.state.showData ? 
                  <FlatList 
                    data={this.state.data.Search}
                    renderItem = {({item}) => {
                      return(
                        <ScrollView horizontal={true}>
                          <List  style={{flex : 1,width : Dimensions.get("screen").width}}>
                                <ListItem thumbnail style={{flex : 1}}>                   
                                    {item.Poster != "N/A" ?
                                        <Left>
                                            <TouchableWithoutFeedback onPress={()=>{this.props.navigation.navigate("Movie",{ id : item.imdbID })}}>
                                                <Thumbnail  style={styles.poster} source={{ uri : item.Poster }} />
                                            </TouchableWithoutFeedback>
                                        </Left>
                                    : 
                                    <View>
                                        <AntDesign name="unknowfile1" size={30} color="white" />
                                    </View> }
                                    <Body>
                                        <Text style={styles.movieInfo}>{item.Title}</Text>
                                        <Text note numberOfLines={1} style={styles.movieInfo}>Year - {item.Year}</Text>
                                    </Body>
                            </ListItem>
                        </List>
                       </ScrollView>
                      )
                    }}                                              
                    keyExtractor = {(item) => item.imdbID + Math.random()}
                  />
                : 
                <View>
                  <Text  style={{color : "white"}}>{this.state.message}</Text>
                </View>}
            </View>
            
           </ScrollView>
          </View>
    </TouchableWithoutFeedback>
     
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  form : {
    marginTop : 20
  },
  Form : {
    color : "white"
  },
  label : {
    flex : 1.1,color : "white"
  },
  input : {
    color : "white",flex : 4
  },
  button : {
    flex : 1.8
  },
  btnText : {
    fontSize : 18
  },
//   poster : {
//     width : Dimensions.get("window").width * 0.7,height : Dimensions.get('window').height/2.5,
//   },
  movieInfo : {
    color : "white",
  }
});
