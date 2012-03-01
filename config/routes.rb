Forester::Application.routes.draw do

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "index#index" 
 
  #Routes for page modifying Ajax calls
  match "/add_specie" => "page_controls#add_specie"
  match "/delete_specie" => "page_controls#delete_specie"
  match "/import_jobs_of_partner/:id" => "page_controls#import_jobs_of_partner"
  match "/import_jobs_of_owner/:id" => "page_controls#import_jobs_of_owner"
  match "/import_jobs_of_logger/:id" => "page_controls#import_jobs_of_logger"
  match "/import_jobs_of_trucker/:id" => "page_controls#import_jobs_of_trucker"
  match "/get_receipts/:id" => "page_controls#get_receipts"
  match "/get_load_type/" => "page_controls#get_load_type" 
  match "/get_job_name/:id" => "page_controls#get_job_name"
  match "/get_load_details/:id" => "page_controls#get_load_details"
  
  #Kinda nav stoof
  match "/ticket_entry" => "entry#ticket_entry"
  match "/payment_entry" => "entry#payment_entry"
  match "/comparison" => "entry#comparison"
  match "/deduction"  => "entry#deduction"
  match "/create" => "entry#create"
 
  #Nav tab's stoof
  match "/setup" => "setup#index"
  match "/receipts" => "receipts#index"
  match "/reports" => "reports#index"
  match "/entry" => "entry#entry"
 
  #Entry page functions
  match "/add_ticket_entry_row/" => "entry#add_ticket_entry_row"
  match "/add_payment_entry_row/" => "entry#add_payment_entry_row"
  match "/all_ticket_entries" => "page_controls#all_ticket_entries"
  match "/all_payment_entries" => "page_controls#all_payment_entries"
  match "/save_edited_ticket_entry/:id" => "entry#save_edited_ticket_entry"
  match "/save_edited_payment_entry/:id" => "entry#save_edited_payment_entry"
  match "/delete_ticket/:id" => "entry#delete_ticket"
  match "/delete_payment/:id" => "entry#delete_payment"
  match "/is_this_tn_duplicate/:id" => "entry#is_this_tn_duplicate"
  match "/get_the_inputs_to_ticket/:id" => "page_controls#get_the_inputs_to_ticket"
  match "/get_the_inputs_to_payment/:id" => "page_controls#get_the_inputs_to_payment"
  
  #Setup page's basic page calls
  match "/landowners" => "setup#owners"
  match "/partners" => "setup#partners"
  match "/jobs" => "setup#jobs"
  match "/truckers" => "setup#truckers"
  match "/sawmills" => "setup#sawmills"
  match "/rates" => "setup#rates"
  match "/ticket_ranges" => "setup#ticket_ranges"
  match "/get_existing/:id" => "setup#get_existing"
  
  #Receipt page's basic page calls
  match "/new_receipt" => "receipts#new_receipt"
  match "/owner_receipt" => "receipts#owner_receipt"
  match "/logger_receipt" => "receipts#logger_receipt"
  match "/trucker_receipt" => "receipts#trucker_receipt"  
  match "/search_receipt" => "receipts#search_receipt"
  match "/job_statement" => "receipts#job_statement"
  match "/check_for_receipts/:id" => "receipts#check_for_receipts"
  
  #Receipt page's "pull receipt" calls
  match "/get_owner_receipt" => "receipts#get_owner_receipt"
  match "/get_logger_receipt" => "receipts#get_logger_receipt"
  match "/get_trucker_receipt" => "receipts#get_trucker_receipt"
  match "/get_hfi_receipt" => "receipts#get_hfi_receipt"
  match "/get_old_receipt/" => "receipts#get_old_receipt"
  match "/get_statement/:id" => "receipts#get_statement"
  
  #The receipt modification pages functions
  match "/add_deduction" => "receipts#add_deduction"
  match "/get_owner_tickets/:id" => "page_controls#get_owner_tickets"
  match "/get_logger_tickets/:id" => "page_controls#get_logger_tickets"
  match "/get_trucker_tickets/:id" => "page_controls#get_trucker_tickets"
  match "/get_hfi_tickets/:id" => "page_controls#get_hfi_tickets"
  
  #Report page's basic page calls
  match "/quarterly_report" => "reports#quarterly_report"
  match "/export_database" => "reports#export_database"
  
  #Receipts saving call
  match "/save_owner_receipt" => "receipts#save_owner_receipt"
  match "/save_logger_receipt" => "receipts#save_logger_receipt"
  match "/save_trucker_receipt" => "receipts#save_trucker_receipt"
  match "/save_hfi_receipt" => "receipts#save_hfi_receipt"
  
  #Get the thing!
  match "/export_the_thing/:id" => "reports#export_the_thing"
  match "/exported_report" => "reports#exported_report"
  
  #Setup page's news/edits
  match "/new_job" => "setup#new_job"
  match "/new_rate/:id" => "setup#new_rate"
  match "/new_partner" => "setup#new_partner"
  match "/new_owner" => "setup#new_owner"
  match "/new_sawmill" => "setup#new_sawmill"
  
  match "/edit_rate/:id" => "setup#edit_rate"
  match "/delete_rate/:id" => "setup#delete_rate"
  match "/edit_job" => "setup#edit_job"
  match "/edit_owner" => "setup#edit_owner"
  match "/edit_partner" => "setup#edit_partner"
  match "/edit_sawmill" => "setup#edit_sawmill"
  
  match "/edit_range/:id" => "setup#edit_range"
  match "/new_range/:id" => "setup#new_range"
  match "/delete_range/:id" => "setup#delete_range"

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
