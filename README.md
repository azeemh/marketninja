Bash Script To Generate This Application

```
#!/bin/bash

cd
rails new marketninja --skip-turbolinks --database=postgresql
cd marketninja
rails db:drop
rails db:create
rails db:migrate

###setup home controller
rails g controller home index

#match and replace sed -i -e 's/$match/$replace/g' $file

#change line 2 of config/routes.rb to home route
sed -i '2 c\
  root to: "home#index"' config/routes.rb

###UPDATE GEMFILE###

#match and insert to update gems
match=", group: :development"
insert="gem 'devise'\ngem 'simple_form'"
file='Gemfile'
sed -i "s/$match/$match\n$insert/" $file

bundle install

###install devise###
##adds to gemfile then bundle and devise install, then adds config params and installs views and user model

rails g devise:install
match="# Don't care if the mailer can't send."
insert="  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }"
file="config/environments/development.rb"
sed -i "s/$match/$match\n$insert/" $file
rails g devise:views
rails g devise user

rails g migration AddProfileToUsers username:string:uniq bio:text


###generate app stuff


#update devise registrations with userprofile form fields for edit and new

#replace/update edit registrations html.erb
cat <<'EOF' > app/views/devise/registrations/edit.html.erb
<h2>Edit <%= resource_name.to_s.humanize %></h2>
<%= form_for(resource, as: resource_name, url: registration_path(resource_name), html: { method: :put }) do |f| %>
  <%= devise_error_messages! %>
  <div class="field">
    <%= f.label :username %><br />
    <%= f.text_field :username %>
  </div>
  <div class="field">
    <%= f.label :bio %><br />
    <%= f.text_area :bio %>
  </div>
  <div class="field">
    <%= f.label :email %><br />
    <%= f.email_field :email, autofocus: true %>
  </div>
  <% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
    <div>Currently waiting confirmation for: <%= resource.unconfirmed_email %></div>
  <% end %>
  <div class="field">
    <%= f.label :password %> <i>(leave blank if you don't want to change it)</i><br />
    <%= f.password_field :password, autocomplete: "off" %>
    <% if @minimum_password_length %>
      <br />
      <em><%= @minimum_password_length %> characters minimum</em>
    <% end %>
  </div>
  <div class="field">
    <%= f.label :password_confirmation %><br />
    <%= f.password_field :password_confirmation, autocomplete: "off" %>
  </div>
  <div class="field">
    <%= f.label :current_password %> <i>(we need your current password to confirm your changes)</i><br />
    <%= f.password_field :current_password, autocomplete: "off" %>
  </div>
  <div class="actions">
    <%= f.submit "Update" %>
  </div>
<% end %>
<h3>Cancel my account</h3>
<p>Unhappy? <%= button_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?" }, method: :delete %></p>
<%= link_to "Back", :back %>
EOF

#replace/update new registrations html.erb
cat <<'EOF' > app/views/devise/registrations/new.html.erb
<h2>Sign up</h2>
<%= form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f| %>
  <%= devise_error_messages! %>
  <div class="field">
    <%= f.label :username %><br />
    <%= f.text_field :username %>
  </div>
  <div class="field">
    <%= f.label :bio %><br />
    <%= f.text_area :bio %>
  </div>
  <div class="field">
    <%= f.label :email %><br />
    <%= f.email_field :email, autofocus: true %>
  </div>
  <div class="field">
    <%= f.label :password %>
    <% if @minimum_password_length %>
    <em>(<%= @minimum_password_length %> characters minimum)</em>
    <% end %><br />
    <%= f.password_field :password, autocomplete: "off" %>
  </div>
  <div class="field">
    <%= f.label :password_confirmation %><br />
    <%= f.password_field :password_confirmation, autocomplete: "off" %>
  </div>
  <div class="actions">
    <%= f.submit "Sign up" %>
  </div>
<% end %>
<%= render "devise/shared/links" %>
EOF

cat <<'EOF' > app/views/devise/sessions/new.html.erb
<h2 class="css_class_for_fontName">Log In</h2>

<%= form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>
  <div class="field css_class_for_fontName">
    <%= f.label :email %><br />
    <%= f.email_field :email, autofocus: true %>
  </div>

  <div class="field css_class_for_fontName">
    <%= f.label :password %><br />
    <%= f.password_field :password, autocomplete: "off" %>
  </div>

  <% if devise_mapping.rememberable? -%>
    <div class="field css_class_for_fontName">
      <%= f.check_box :remember_me %>
      <%= f.label :remember_me %>
    </div>
  <% end -%>

  <div class="actions">
    <%= f.submit "Log in" %>
  </div>
<% end %>

<%= render "devise/shared/links" %>
EOF

###updatemodels
#add model references to other generated models
#update user model

#cat <<'EOF' > app/models/user.rb
#class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
         #:recoverable, :rememberable, :trackable, :validatable
#end
#EOF

#update navbar
cat <<'EOF' > app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>

<head>
  <title>Market Ninja</title>
  <%=csrf_meta_tags %>
  <%=stylesheet_link_tag 'application', media: 'all' %>
  <%=javascript_include_tag 'application' %>
  <%=favicon_link_tag 'favicon.ico'%>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.5.1/css/bulma.css">
</head>

<body>
  <div class="mainContainer">
    <section class="navigation">
      <div class="nav-container">
        <div class="brand"><a href="/"><%=image_tag( "logo.png", class: "imglogo") %> Market Ninja</a><!-- need logo image file @ assets/images/logo.png--></div>
        <nav>
          <div class="nav-mobile"><a id="nav-toggle" href="#!"><span></span></a></div>
          <ul>
            <li><a class="css_class_for_fontName" id="homeLink" href="/">Home</a></li>
            <% if user_signed_in? %>
              <li><a class="css_class_for_fontName" href="/categories">Category</a></li>
              <li><a class="css_class_for_fontName" href="/offers">Offer</a></li>
              <li><a class="css_class_for_fontName" href="/suppliers">Supplier</a></li>
              <li><a class="css_class_for_fontName" href="<%= edit_user_registration_path %>"><% if !current_user.username == '' %><%= current_user.username %><% else %><%= current_user.email %></a><% end %></li>
              <li><%= link_to "Log Out", destroy_user_session_path, method: :delete, :class=> "css_class_for_fontName" %></li>
            <% else %>
              <li><%= link_to "Log In", new_user_session_path, :class=> "css_class_for_fontName" %></li>
            <% end %>
              <li style="text-align: center;"><a class="css_class_for_fontName" id="closeLink" href="#" style="font-height: 2em; font-weight: 900;">×</a></li>
          </ul>
        </nav>
      </div>
    </section>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
    <script>
      function myFunction() {
        var x = document.getElementById('navbar');
        if (x.style.display === 'none') {
          x.style.display = 'block';
        } else {
          x.style.display = 'none';
        }
        var y = document.getElementById('mobile');
        if (y.style.display === 'inline') {
          y.style.display = 'none';
        } else {
          y.style.display = 'inline';
        }
      }

      (function($) { // Begin jQuery
        $(function() { // DOM ready
          // If a link has a dropdown, add sub menu toggle.
          $(window).resize(function() {
            if ($(window).width() > 800) {
              $('nav ul').show();
              $('#homeLink').hide();
              $('#closeLink').hide();
            } else {
              $('#homeLink').show();
              $('#closeLink').show();
            }
          });
          $('#homeLink').hide();
          $('#closeLink').hide();

          $('nav ul li a:not(:only-child)').click(function(e) {
            $(this).siblings('.nav-dropdown').toggle();
            // Close one dropdown when selecting another
            $('.nav-dropdown').not($(this).siblings()).hide();
            e.stopPropagation();
          });
          // Clicking the 'close' button from dropdown will remove the dropdown class
          $('#closeLink').click(function() {
            $('nav ul').hide();
          });
          // Toggle open and close nav styles on click
          $('#nav-toggle').click(function() {
            $('nav ul').slideToggle();
          });
          // Hamburger to X toggle
          $('#nav-toggle').on('click', function() {
            $('#homeLink').show();
            $('#closeLink').show();
            this.classList.toggle('active');
          });
        }); // end DOM ready
      })(jQuery); // end jQuery
    </script>
    <section>
      <% if !notice.nil? %>
      <div class="notice"><%= notice %></div>
      <% end %>
      <% if !alert.nil? %>
      <div class="alert"><%= alert %></div><% end %>
    </section>
    <div id="yieldContainer">
      <%= yield %>
    </div>
  </div>
</body>

<footer class="css_class_for_fontName">
  <div class="columns">
    <div class="column footerText">
      <h2 class="headline">This should be your appname like Market Ninja or something actually useful like maybe a row of social media icons and links etc</h2>
    </div>
    <div class="column footerText">
      <h4>© <%= Date.today.year %> yourcompanyname</h4>
    </div>
    <div class="column footerText">
      <h4>Contact us at <a href="mailto:adefaultemail@awebsite.com">dude@chillworkspace.com</a></h4>
    </div>
  </div>
</footer>

</html>
EOF

#update application_controller
cat <<'EOF' > app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :bio])
  end
end
EOF
rails generate scaffold Category name:string

rails generate scaffold Offer product_name:string platform:string virability:decimal date_ad_posted:date price:decimal product_details:text link:string keywords:string video_link:string category:references

cd db/migrate
filename=`ls | sort | tail -1`
echo $filename
cat <<'EOF' > $filename
class CreateOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :offers do |t|
      t.string :product_name
      t.string :platform
      t.decimal :virability
      t.date :date_ad_posted
      t.decimal :price
      t.text :product_details
      t.string :link
      t.string :keywords
      t.string :video_link
      t.references :category, foreign_key: true
      t.references :categorizable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
EOF
cd
cd marketninja

cat <<'EOF' > app/models/offer.rb
class Offer < ApplicationRecord
  belongs_to :categorizable, :polymorphic => true, optional: true
end
EOF

cat <<'EOF' > app/models/category.rb
class Category < ApplicationRecord
  has_many :offers, :as => :categorizable
end
EOF

#rails db:migrate

cat <<'EOF' > app/views/offers/_form.html.erb
<%= form_with(model: offer, local: true) do |form| %>
  <% if offer.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(offer.errors.count, "error") %> prohibited this offer from being saved:</h2>

      <ul>
      <% offer.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= form.label :product_name %>
    <%= form.text_field :product_name, id: :offer_product_name %>
  </div>

  <div class="field">
    <%= form.label :platform %>
    <%= form.text_field :platform, id: :offer_platform %>
  </div>

  <div class="field">
    <%= form.label :virability %>
    <%= form.text_field :virability, id: :offer_virability %>
  </div>

  <div class="field">
    <%= form.label :date_ad_posted %>
    <%= form.date_select :date_ad_posted, id: :offer_date_ad_posted %>
  </div>

  <div class="field">
    <%= form.label :price %>
    <%= form.text_field :price, id: :offer_price %>
  </div>

  <div class="field">
    <%= form.label :product_details %>
    <%= form.text_area :product_details, id: :offer_product_details %>
  </div>

  <div class="field">
    <%= form.label :link %>
    <%= form.text_field :link, id: :offer_link %>
  </div>

  <div class="field">
    <%= form.label :keywords %>
    <%= form.text_field :keywords, id: :offer_keywords %>
  </div>

  <div class="field">
    <%= form.label :video_link %>
    <%= form.text_field :video_link, id: :offer_video_link %>
  </div>

  <div class="field">
    <%= form.label :category_id %>
   
    <%= form.collection_select(:category_id, Category.all, :id, :name) %>
  </div>

  <div class="actions">
    <%= form.submit %>
  </div>
<% end %>
EOF

cat <<'EOF' > app/views/offers/show.html.erb
<p id="notice"><%= notice %></p>

<p>
  <strong>Product name:</strong>
  <%= @offer.product_name %>
</p>

<p>
  <strong>Platform:</strong>
  <%= @offer.platform %>
</p>

<p>
  <strong>Virability:</strong>
  <%= @offer.virability %>
</p>

<p>
  <strong>Date ad posted:</strong>
  <%= @offer.date_ad_posted %>
</p>

<p>
  <strong>Price:</strong>
  <%= @offer.price %>
</p>

<p>
  <strong>Product details:</strong>
  <%= @offer.product_details %>
</p>

<p>
  <strong>Link:</strong>
  <%= @offer.link %>
</p>

<p>
  <strong>Keywords:</strong>
  <%= @offer.keywords %>
</p>

<p>
  <strong>Video link:</strong>
  <%= @offer.video_link %>
</p>

<p>
  <strong>Category:</strong>
  <%= Category.find(@offer.category_id).name %>
</p>

<%= link_to 'Edit', edit_offer_path(@offer) %> |
<%= link_to 'Back', offers_path %>
EOF

cat <<'EOF' > app/views/offers/index.html.erb
<p id="notice"><%= notice %></p>

<h1>Offers</h1>

<table>
  <thead>
    <tr>
      <th>Product name</th>
      <th>Platform</th>
      <th>Virability</th>
      <th>Date ad posted</th>
      <th>Price</th>
      <th>Product details</th>
      <th>Link</th>
      <th>Keywords</th>
      <th>Video link</th>
      <th>Category</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @offers.each do |offer| %>
      <tr>
        <td><%= offer.product_name %></td>
        <td><%= offer.platform %></td>
        <td><%= offer.virability %></td>
        <td><%= offer.date_ad_posted %></td>
        <td><%= offer.price %></td>
        <td><%= offer.product_details %></td>
        <td><%= offer.link %></td>
        <td><%= offer.keywords %></td>
        <td><%= offer.video_link %></td>
        <td><%= Category.find(offer.category_id).name %></td>
        <td><%= link_to 'Show', offer %></td>
        <td><%= link_to 'Edit', edit_offer_path(offer) %></td>
        <td><%= link_to 'Destroy', offer, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New Offer', new_offer_path %>
EOF

rails generate scaffold Supplier name:string platform:string link:string category:references
cd db/migrate
filename=`ls | sort | tail -1`
echo $filename
cat <<'EOF' > $filename
class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :platform
      t.string :link
      t.references :category, foreign_key: true
      t.references :categorizable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
EOF
cd
cd marketninja


cat <<'EOF' > app/models/supplier.rb
class Supplier < ApplicationRecord
  #belongs_to :category
  belongs_to :categorizable, :polymorphic => true, optional: true
end
EOF

cat <<'EOF' > app/models/category.rb
class Category < ApplicationRecord
  has_many :offers, :as => :categorizable
  has_many :suppliers, :as => :categorizable
end
EOF



#rails db:migrate

cat <<'EOF' > app/views/suppliers/_form.html.erb
<%= form_with(model: supplier, local: true) do |form| %>
  <% if supplier.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(supplier.errors.count, "error") %> prohibited this supplier from being saved:</h2>

      <ul>
      <% supplier.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= form.label :name %>
    <%= form.text_field :name, id: :supplier_name %>
  </div>

  <div class="field">
    <%= form.label :platform %>
    <%= form.text_field :platform, id: :supplier_platform %>
  </div>

  <div class="field">
    <%= form.label :link %>
    <%= form.text_field :link, id: :supplier_link %>
  </div>

  <div class="field">
    <%= form.label :category_id %>
    <%= form.collection_select(:category_id, Category.all, :id, :name) %>
  </div>

  <div class="actions">
    <%= form.submit %>
  </div>
<% end %>
EOF

cat <<'EOF' > app/views/suppliers/index.html.erb
<p id="notice"><%= notice %></p>

<h1>Suppliers</h1>

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Platform</th>
      <th>Link</th>
      <th>Category</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @suppliers.each do |supplier| %>
      <tr>
        <td><%= supplier.name %></td>
        <td><%= supplier.platform %></td>
        <td><%= supplier.link %></td>
        <td><%= Category.find(supplier.category_id).name %></td>
        <td><%= link_to 'Show', supplier %></td>
        <td><%= link_to 'Edit', edit_supplier_path(supplier) %></td>
        <td><%= link_to 'Destroy', supplier, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New Supplier', new_supplier_path %>
EOF

cat <<'EOF' > app/views/suppliers/show.html.erb
<p id="notice"><%= notice %></p>

<p>
  <strong>Name:</strong>
  <%= @supplier.name %>
</p>

<p>
  <strong>Platform:</strong>
  <%= @supplier.platform %>
</p>

<p>
  <strong>Link:</strong>
  <%= @supplier.link %>
</p>

<p>
  <strong>Category:</strong>
  <%= Category.find(@supplier.category_id).name %>
</p>

<%= link_to 'Edit', edit_supplier_path(@supplier) %> |
<%= link_to 'Back', suppliers_path %>
EOF


#update navigation styles and create nav.scss
cat <<'EOF' > app/assets/stylesheets/nav.scss
html, body{
  margin:0px!important;
  height: 100%;
}
.logo {
  background: none;
}
.imglogo {
  height: 40px;
  width: auto;
  padding-left: 20px;
  top: 10px;
  position: relative;
}

.mainContainer{
  min-height: 100%;
  padding-top: 100px; /* must be at least 70px or > than navbar height. add 10 px for actual padding. */
  padding-bottom: 100px; /* must be at least 70px > than footer height. */
}

footer{
  background-color: #262626;
  color: white;
  min-height: 15vh;/*made it high for codepens window*/
  text-align:center;
}
.headline-right{
  text-align: right;
}
.footerText{
  margin-top: 20px;
}
footer a:hover{
  color:#1affc6;
}
.homeWelcome{
  text-align: center;
  font-size: 10vh;
}

// Navigation Variables
$content-width: 100%;
$breakpoint: 800px;
$nav-height: 70px;
$nav-background: #262626;
$nav-font-color: #ffffff;
$link-hover-color: #2581DC;
// Outer navigation wrapper
.navigation {
  height: $nav-height;
  background: $nav-background;
  //overflow: hidden;
  position: fixed;
  top: 0;
  width: 100%;
  z-index: 1;
  padding-left:2%;
  padding-right:2%;
}
// Logo and branding
.brand {
  position: absolute;
  padding-left: 0px;
  float: left;
  line-height: $nav-height;
  text-transform: uppercase;
  font-size: 1.4em;
  a,
  a:visited {
    color: $nav-font-color;
    text-decoration: none;
  }
}
// Container with no padding for navbar
.nav-container {
  max-width: $content-width;
  margin: 0 auto;
}
// Navigation 
.nav-buttons{
  padding-right:0px;
}
nav { 
  float: right;
  padding-top:0px!important;
  ul {
    list-style: none;
    margin: 0;
    padding: 0;
    li {
      float: left;
      position: relative;
      a,
      a:visited {
        display: block;
        padding-left:5px;
        padding-right:5px;
        border-radius:0px!important;
        line-height: $nav-height;
        background: $nav-background;
        color: $nav-font-color;
        text-decoration: none;
        &:hover {
          background: $link-hover-color;
          color: $nav-font-color;
        }
        &:not(:only-child):after {
          padding-left: 4px;
          content: ' ▾';
        }
      } // Dropdown list
      ul li {
        min-width: 190px;
        a {
          padding: 15px;
          line-height: 20px;
        }
      }
    }
  }
}
// Dropdown list binds to JS toggle event
.nav-dropdown {
  position: absolute;
  display: none;
  z-index: 1;
  box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15);
}
/* Mobile navigation */
// Binds to JS Toggle
.nav-mobile {
  display: none;
  position: absolute;
  top: 0;
  right: 0;
  background: $nav-background;
  height: $nav-height;
  width: $nav-height;
}
@media only screen and (max-width: $breakpoint) {
  // Hamburger nav visible on mobile only
  .nav-mobile {
    display: block;
  }
  nav {
   width: 100%;
    padding: $nav-height 0 15px;
    ul {
      display: none;
      li {
        float: none;
        a {
          padding: 15px;
          line-height: 20px;
        }
        ul li a {
          padding-left: 30px;
        }
      }
    }
  }
  .nav-dropdown {
    position: static;
  }
}
@media screen and (min-width: $breakpoint) {
  .nav-list {
    display: block !important;
  }
}
#nav-toggle {
  position: absolute;
  left: 18px;
  top: 22px;
  cursor: pointer;
  padding: 10px 35px 16px 0px;
  span,
  span:before,
  span:after {
    cursor: pointer;
    border-radius: 1px;
    height: 5px;
    width: 35px;
    background: $nav-font-color;html, body {
  margin: 0px !important;
  height: 100%;
}
.filler {
  height: 15vh;
}
.mainContainer {
  min-height: 100%;
}
footer {
  background-color: #262626;
  color: white;
  min-height: 15vh; /*made it high for codepens window*/
  text-align: center;
}
.headline-right {
  text-align: right;
}
.footerText {
  margin-top: 20px;
}
footer a:hover {
  color: #1affc6;
}
.homeWelcome {
  text-align: center;
  font-size: 10vh;
}
@media only screen and (max-height: 550px) {
  .filler {
    min-height: 45vh;
  }
}
// Navigation Variables
$content-width: 100%;
$breakpoint: 800px;
$nav-height: 70px;
$nav-background: #262626;
$nav-font-color: #ffffff;
$link-hover-color: #2581DC;
// Outer navigation wrapper
.navigation {
  height: $nav-height;
  background: $nav-background;
  //overflow: hidden;
  position: fixed;
  top: 0;
  width: 100%;
  z-index: 1;
  padding-left: 2%;
  padding-right: 2%;
}
// Logo and branding
.brand {
  position: absolute;
  padding-left: 0px;
  float: left;
  line-height: $nav-height;
  text-transform: uppercase;
  font-size: 1.4em;
  a, a:visited {
    color: $nav-font-color;
    text-decoration: none;
  }
}
// Container with no padding for navbar
.nav-container {
  max-width: $content-width;
  margin: 0 auto;
}
// Navigation
.nav-buttons {
  padding-right: 0px;
}
nav {
  float: right;
  padding-top: 0px !important;
  ul {
    list-style: none;
    margin: 0;
    padding: 0;
    li {
      float: left;
      position: relative;
      a, a:visited {
        display: block;
        padding-left: 5px;
        padding-right: 5px;
        border-radius: 0px !important;
        line-height: $nav-height;
        background: $nav-background;
        color: $nav-font-color;
        text-decoration: none;
        &:hover {
          background: $link-hover-color;
          color: $nav-font-color;
        }
        &:not(:only-child):after {
          padding-left: 4px;
          content: ' ▾';
        }
      } // Dropdown list
      ul li {
        min-width: 190px;
        a {
          padding: 15px;
          line-height: 20px;
        }
      }
    }
  }
}
// Dropdown list binds to JS toggle event
.nav-dropdown {
  position: absolute;
  display: none;
  z-index: 1;
  box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15);
}
/* Mobile navigation */
// Binds to JS Toggle
.nav-mobile {
  display: none;
  position: absolute;
  top: 0;
  right: 0;
  background: $nav-background;
  height: $nav-height;
  width: $nav-height;
}
@media only screen and (max-width: $breakpoint) {
  // Hamburger nav visible on mobile only
  .nav-mobile {
    display: block;
  }
  nav {
    width: 100%;
    padding: $nav-height 0 15px;
    ul {
      display: none;
      li {
        float: none;
        a {
          padding: 15px;
          line-height: 20px;
        }
        ul li a {
          padding-left: 30px;
        }
      }
    }
  }
  .nav-dropdown {
    position: static;
  }
}
@media screen and (min-width: $breakpoint) {
  .nav-list {
    display: block !important;
  }
}
#nav-toggle {
  position: absolute;
  left: 18px;
  top: 22px;
  cursor: pointer;
  padding: 10px 35px 16px 0px;
  span, span:before, span:after {
    cursor: pointer;
    border-radius: 1px;
    height: 5px;
    width: 35px;
    background: $nav-font-color;
    position: absolute;
    display: block;
    content: '';
    transition: all 300ms ease-in-out;
  }
  span:before {
    top: -10px;
  }
  span:after {
    bottom: -10px;
  }
  /*  &.active span {
    background-color: transparent;
    &:before,
    &:after {
      top: 0;
    }
    &:before {
      transform: rotate(45deg);
    }
    &:after {
      transform: rotate(-45deg);
    }
  }*/
}
// Page content
article {
  max-width: $content-width;
  margin: 0 auto;
  padding: 10px;
}
@media only screen and (max-height: 550px) {
  .filler {
    min-height: 45vh;
  }
}
    position: absolute;
    display: block;
    content: '';
    transition: all 300ms ease-in-out;
  }
  span:before {
    top: -10px;
  }
  span:after {
    bottom: -10px;
  }
/*  &.active span {
    background-color: transparent;
    &:before,
    &:after {
      top: 0;
    }
    &:before {
      transform: rotate(45deg);
    }
    &:after {
      transform: rotate(-45deg);
    }
  }*/
}
// Page content 
article {
  max-width: $content-width;
  margin: 0 auto;
  padding: 10px;
}
@media only screen and (max-height: 550px) {
  .filler{
    min-height: 45vh;
  }
}
EOF


#override scaffolds.scss
cat <<'EOF' > app/assets/stylesheets/scaffolds.scss
body {
  background-color: #fff;
  color: #333;
  /*font-family: verdana, arial, helvetica, sans-serif;
  font-size: 13px;*/
  /*line-height: 18px;*/
}
p, ol, ul, td {
  /*font-family: verdana, arial, helvetica, sans-serif;*/
  /*font-size: 13px;*/
  line-height: 18px;
}
pre {
  background-color: #eee;
  padding: 10px;
  /*font-size: 11px;*/
}
th {
  padding-bottom: 5px;
}
td {
  padding: 0 5px 7px;
}
div {
  &.field, &.actions {
    margin-bottom: 10px;
  }
}
#notice {
  color: green;
}
.field_with_errors {
  background-color: crimson;
  text-align: center;
  color: white;
}
#error_explanation {
  width: 98.5%;
  border: 2px solid crimson;
  padding: 7px 7px 0;
  margin-bottom: 20px;
  h2 {
    text-align: left;
    font-weight: bold;
    padding: 5px 5px 5px 15px;
    font-size: 12px;
    margin: -7px -7px 0;
    background-color: crimson;
    color: #fff;
  }
  ul li {
    font-size: 12px;
    list-style: square;
  }
}
label {
  //display: inline-block;
}
form {
  width: 95%;
  padding-left: 2.5%;
}
.field {
  width: 100%;
  textarea {
    width: 100%;
    min-height: 200px;
    border-radius: 3px;
    border: 1px dotted black;
  }
  input {
    width: 100%;
    min-height: 30px;
    border-top: none;
    border-left: none;
    border-right: none;
    border-bottom: 2px solid black;
  }
}
EOF

rails db:migrate
```
