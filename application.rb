require "sinatra"

input_file="symbols.markdown"
generated_file="views/generated.erb"
header_pattern=/###/

def to_classnames(a_string)
  a_string.strip.gsub("=", " ").gsub(":", " ")
end

def to_file_name(a_string)
  a_string.strip.gsub(":", "_")
end

def to_title(a_string)
  
end

def process_html(l)
  unless l.empty? or l =="\n"
    if (l =~ header_pattern)
      file << "<h2>"  + l.gsub(header_pattern, "").strip + "</h2>" + "\n"
    else
      file << "<div class='item " + to_classnames(l) + "'>"  + "<object data='icons/#{to_file_name(l)}.svg' type='image/svg+xml' width='50' height='50'></object>" + "<object class='large' data='icons/#{to_file_name(l)}.svg' type='image/svg+xml' width='50' height='50'></object>" + l.strip + "</a></div>" + "\n <span class='attribution'>attribution</span>"
    end
  end
end

def process_mediawiki(l)
  unless l.empty? or l =="\n"
    if (l =~ header_pattern)
      # skip
    else
      file << to_classnames(l) + "[['icons/#{to_file_name(l)}.svg' width='50' height='50']]" + "\n <span class='attribution'>attribution</span>"
    end
  end
end



get "/generate" do # recreate and read the generated file
  
  File.delete(generated_file)
  
  open(generated_file, "a+") do |file|
    input = File.open(input_file, "r").readlines
    input.each do |l|
      if params[:process_mediawiki]
        process_mediawiki(l)
      else
        process_html(l)
      end
    end
  end
  
  erb :generated
end

get "/" do # read the generated file
  erb :generated
end
