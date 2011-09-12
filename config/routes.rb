Forester::Application.routes.draw do

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "index#index" 
 
  #Routes for page modifying Ajax calls
  match "/add_specie" => "page_controls#add_specie"
  match "/delete_specie" => "page_controls#delete_specie"
  match "/import_jobs/:id" => "page_controls#import_jobs"
  match "/import_jobs_of_logger/:id" => "page_controls#import_jobs_of_logger"
  match "/import_jobs_of_trucker/:id" => "page_controls#import_jobs_of_trucker"
  
  #Kinda nav stoof
  match "/ticket_entry" => "entry#ticket_entry"
  match "/payment_entry" => "entry#payment_entry"
 
  #Nav tab's stoof
  match "/setup" => "setup#index"
  match "/receipts" => "receipts#index"
  match "/reports" => "reports#index"
  match "/entry" => "entry#entry"
 
  match "/add_entry_row" => "entry#add_entry_row", :via => "post"
 
  match "/landowners" => "setup#owners"
  match "/partners" => "setup#partners"
  match "/jobs" => "setup#jobs"
  match "/truckers" => "setup#truckers"
  match "/sawmills" => "setup#sawmills"
  
  match "/printable_owner_receipt/:id" => "reports#printable_owner_receipt"
  
  match "/owner_receipt" => "receipts#owner_receipt"
  match "/logger_receipt" => "receipts#logger_receipt"
  match "/trucker_receipt" => "receipts#trucker_receipt"  
  
  match "/quarterly_report" => "reports#quarterly_report"
  match "/export_database" => "reports#export_database"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
