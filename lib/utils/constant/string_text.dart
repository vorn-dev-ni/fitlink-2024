class StringAsset {
  StringAsset._();

  static const welcomeScreen = "Welcome Home";
  static const scanBtnTop = 'Gym and Equipment';
  static const bodyGym = 'Look up for machine tools at the gym';

  static const scanBtnBottom = 'Foods and Calories';
  static const detailFoods = 'Detail about your foods';

  static const account = 'Account';

  static const prompsGym = """
with the following image pls  tell me what is this machine in gym pls response back as json object with {
    "name" , "summary", ( make it short )
    "exercise", "set", "rep" , "calories burn per set as string ( 300-1000 kcal) "
    "target_muscles" ,
    "instructions"    array of string no need to add note or description of your word no need to return me both at the same time only return either error or the answer  f user submit image that is not related to that pls return error with key code, message as json object 
""";
  static const prompsFoodCalories = '''

with the following image pls rate my foods and response as json object with the following fields : rating, title, comment, calories with it units, fat, proteins, sugar as gram , carbohydrates , rating overall out of 5 or  , similar  recommendation  (includes calories, proteins,  sugar ) that it and just like the above no need to add extra note or info I just need that and  if user submit image that is not related to that pls return error with key code, message as json object pls no need to response with note for me for each calories, fat, protein I want it as object
 { iconType: enum that has fat, calories, protein, sugar, carbohydrate, value:'300g', title:'calroeis'} pls apply all to the related sugar, fat,.. i want it to be like this
{
    "rating": 3,
    "title": "Cheeseburger",
    "comment": "A classic American favorite, but high in fat and calories.",
    "nutrition_facts": [
        {
            "iconType": "calories",
            "value": "500-800 kcal",
            "title": "Calories"
        },
        {
            "iconType": "fat",
            "value": "30-40g",
            "title": "Fat"
        },
        {
            "iconType": "protein",
            "value": "20-30g",
            "title": "Protein"
        },
        {
            "iconType": "sugar",
            "value": "10-20g",
            "title": "Sugar"
        },
        
        {
            "iconType": "carbohydrate",
            "value": "30-40g",
            "title": "Carbohydrates"
        },
          {
            "iconType": "rating",
            "value": "4/5",
            "title": "Rating"
        },
    ],
    "isHealthy": false,
    "similar_recommendations": [
        {
            "title": "Turkey Burger",
            "nutrition_facts": [
                {
                    "iconType": "calories",
                    "value": "300-400 kcal",
                    "title": "Calories"
                },
              
                {
                    "iconType": "protein",
                    "value": "25-35g",
                    "title": "Protein"
                },
                {
                    "iconType": "sugar",
                    "value": "5-10g",
                    "title": "Sugar"
                },
             
            ]
        },
       
    ]
}

  ''';
}
