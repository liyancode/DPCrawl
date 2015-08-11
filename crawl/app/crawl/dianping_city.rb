require 'nokogiri'
require 'watir-webdriver'
require 'sequel'


DB=Sequel.connect('postgres://***:***@localhost:5432/dianping')

require_relative '../models/city'

def get_city_info(terms_div_ele)
  begin
    a_list=terms_div_ele.children
    city_info_list=[]
    a_list.each{|ele|
      if ele.name=="a"
        city_info_list<<[0,ele.children[0].text,ele.attributes["href"].value,'other info']
      end
    }
    return city_info_list
  rescue Exception=>e
    p e
  end

end

# p "#====>open firefox to load page ..."
# DP_Citylist_Page_URL="http://www.dianping.com/citylist"
# browser = Watir::Browser.new :firefox
# browser.goto(DP_Citylist_Page_URL)
html=Nokogiri::HTML(File.read('html.html'))
# browser.close
p "#====>page html loaded."

p "#====>to get DP city list..."
city_list=[]
children= html.root.children
p '37'
ul_city_list=children[3].children[9].children[1].children[1]
p '39'
ul_city_list.children.each{|child|
  p 41
  p child.children[3]
  if child.class!=Nokogiri::XML::Text
    city_list=city_list.concat(get_city_info(child.children[3]))
  end
}
p "#====>to insert data to DB..."
City.insert(city_list)
p "#====>finished."


