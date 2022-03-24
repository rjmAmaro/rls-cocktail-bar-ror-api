# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Category.all.delete_all

=begin
categories = RestClient.get('www.thecocktaildb.com/api/json/v1/1/list.php?c=list')
parsed_categories = JSON.parse(categories.body)["drinks"]
parsed_categories.each do|ct|
  new_category = Category.create(name:ct['strCategory'])
  c_cocktails = RestClient.get("www.thecocktaildb.com/api/json/v1/1/filter.php?c=#{new_category.name.gsub(' ','_')}")
  parsed_cocktails = JSON.parse(c_cocktails.body)["drinks"]
  parsed_cocktails.each do|ck|
    Cocktail.create(name:ck["strDrink"], photo:ck["strDrinkThumb"], desc: "description", category: new_category)
  end
end
=end
current_letter="a"
last_letter="z"

while current_letter <= last_letter
  cocktails = RestClient.get("www.thecocktaildb.com/api/json/v1/1/search.php?f=#{current_letter}")
  cocktails=JSON.parse(cocktails.body)["drinks"]
  if cocktails
    cocktails.each do |cocktail|
      new_cocktail = Cocktail.new
      new_cocktail.strDrink = cocktail["strDrink"]
      new_cocktail.strDrinkThumb = cocktail["strDrinkThumb"]
      new_cocktail.strInstructions = cocktail["strInstructions"]

      category = Category.find_by(strCategory: cocktail["strCategory"])
      unless category
        category = Category.create(strCategory: cocktail["strCategory"])
        category.save
      end

      new_cocktail.category = category

      #puts "TOU VIVO"
      current_ingredient = cocktail["strIngredient1"]
      n_ingredient = 1
      while current_ingredient
        image_link=nil
        if current_ingredient == "J\u00E4germeister"
          ingredients = RestClient.get("www.thecocktaildb.com/api/json/v1/1/lookup.php?iid=278")
          image_link="www.thecocktaildb.com/images/ingredients/jagermeister.png"
        elsif current_ingredient == "A\u00F1ejo rum"
          ingredients = RestClient.get("www.thecocktaildb.com/api/json/v1/1/lookup.php?iid=37")
          image_link="www.thecocktaildb.com/images/ingredients/anejo rum.png"
        else
          ingredients = RestClient.get("www.thecocktaildb.com/api/json/v1/1/search.php?i=#{current_ingredient}")
        end
        raw_ingredient = JSON.parse(ingredients.body)["ingredients"][0]

        #raw_ingredient = ingredients.find(strIngredient: current_ingredient)

        ingredient = Ingredient.find_by(strIngredient: raw_ingredient["strIngredient"])
        puts ingredient
        p ingredient
        flag = "ENCONTROU"

        if ingredient.nil?
          if image_link.nil?
            image_link="www.thecocktaildb.com/images/ingredients/#{raw_ingredient["strIngredient"].downcase.gsub(" ","%20")}.png"
          end
          puts "new #{image_link}"
          ingredient = Ingredient.new
          ingredient.strIngredient =  raw_ingredient["strIngredient"]
          ingredient.strDescription = raw_ingredient["strDescription"]
          ingredient.strImageSource = image_link
          ingredient.save
          flag = "CRIOU"
        end

        new_cocktail.ingredients.push(ingredient)

        puts n_ingredient
        puts current_ingredient
        puts flag
        puts "\n\n"

        n_ingredient+=1
        current_ingredient = cocktail["strIngredient#{n_ingredient}"]
      end

      new_cocktail.save
    end
  end
  ascii_code = current_letter.ord
  ascii_code+=1
  current_letter=ascii_code.chr
end