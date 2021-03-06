class Recipe
  attr_reader :title, :url, :uri, :image_url, :ingredients, :health_labels, :diet_labels, :nutrition_facts

  def initialize(params)
    @title = params[:title]
    @url = params[:url]
    @uri = params[:uri]
    @image_url = params[:image_url]
    @ingredients = params[:ingredients]
    @health_labels = params[:health_labels]
    @diet_labels = params[:diet_labels]
    @nutrition_facts = params[:nutrition_facts]
  end

  def self.create_multiple_from_edamam(results)
    results.map do |result|
      self.create_from_edamam(result["recipe"])
    end
  end

  def self.create_from_edamam(recipe)

    # API abbreviations for fat, carbs, fiber, sugar, protein, cholesterol, sodium
    key_nutrients = [
      "FAT", "CHOCDF", "FIBTG", "SUGAR", "PROCNT", "CHOLE"
    ]

    Recipe.new(
      title: recipe["label"],
      url: recipe["url"],
      uri: recipe["uri"].gsub("#","%23"),
      image_url: recipe["image"],
      ingredients: recipe["ingredientLines"],
      health_labels: recipe["healthLabels"],
      diet_labels: recipe["dietLabels"],
      nutrition_facts:
        recipe["totalNutrients"].select { |key, val|
          key_nutrients.include? key
        }.values
    )
  end

end
