var Follower = Backbone.Model.extend({
	base : "/home/followers",
	
	url : function() {
	      if (this.isNew()) return this.base;
	      return this.base + '/' + this.id;
	    },
	
	parse : function(resp, xhr){
		this.id = this.attributes.user_id;
		return {value : true};
	},
	
	check : function(user_id){
		if(user_id) {this.attributes.user_id = user_id;}
		options ={};
		var model = this;
	    options.error = function(resp, status, xhr) {
	        if(status.status == '404') {
				model.set({value : false});
			}
	      };
	
		if(this.isNew()) { 
			options.url = this.base+"/"+this.attributes.user_id;
		}
		else {options.url = this.url();}
	//	console.log(options.url);
		this.fetch(options);	
	},
});