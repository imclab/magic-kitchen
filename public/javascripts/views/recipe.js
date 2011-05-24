MK.Views.Recipe = Backbone.View.extend({
	
	//template : new EJS({url : '/javascripts/views/recipe.ejs'}),
	
	
	tagName : "li",
	//className : "recipe",
 //	id : "",
	// 
	initialize : function(options){
		this.template = new EJS({url : '/javascripts/views/recipe.ejs'}); 
	//	passer {model : recipeinstance} en argument
		this.id = "recipe"+options.model.id;
		//_.bindAll()
		//$(this.el).delegate(".topp","click" , this.addWith);
		//$(this.el).delegate(".bott","click" , this.addWithout);
	//TODO binder les changements sur les models
		_.bindAll(this, "render", "remove")
		this.model.bind("change", this.render);
		this.model.bind("remove", this.remove);
	},
	
	addWith : function(event){
		index = $(event.target).data("ingredient");
		ing = this.model.attributes.ingredients[index];
		
		if(this.model.collection && this.model.collection.addWithIngredient){
			this.model.collection.addWithIngredient(ing);
		}
		return false;
	},
	
	addWithout : function(event){
		index = $(event.target).data("ingredient");
		ing = this.model.attributes.ingredients[index];
		
		if(this.model.collection && this.model.collection.addWithoutIngredient){
			this.model.collection.addWithoutIngredient(ing);
		}
		return false;
	},
	
	// 
	events : {
		"click .like_pic"		: "clickLike",
		"click .check_pic"		: "clickDone",
		"click .star_pic"		: "clickFavorite",
		"click .foll_pic"		: "clickFollow",
		"click .topp"			: "addWithout",
		"click .bott"			: "addWith"
	// 	// 	//event edit handle by route controler
	},
	
	render : function(){
		var data = this.model.toJSON();
		$(this.el).html(this.template.render(data));
		return this;
	},
	
	remove: function() {
		console.log("remove lll");
      $(this.el).remove();
    },
	
	clickLike : function(){
		if(!this.model.like.attributes.value){
			this.model.like.save();
		}
		else{
			this.model.like.destroy();
		}
	},
	
	clickDone : function(){
		this.model.histories.addHistory();
	},
	
	clickFavorite : function(){
		if(!this.model.favorite.attributes.value){
			this.model.favorite.save();
		}
		else{
			this.model.favorite.destroy();
		}
	},
	
	clickFollow : function(){
		if(!this.model.author.following.attributes.value){
			this.model.author.following.save();
		}
		else{
			this.model.author.following.destroy();
		}
	}
	
	
});