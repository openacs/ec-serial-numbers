ad_page_contract {
    Index page.

    @author Joe Cooper (joe@virtualmin.com)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-08-18
} {
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ ec-serial-numbers.ec_serial_numbers]"
set context_bar [ad_context_bar]
set package_id [ad_conn package_id]
set categories_node_id [db_string get_category_node_id {}]
set categories_url [site_node::get_url -node_id $categories_node_id]

ad_return_template
    
