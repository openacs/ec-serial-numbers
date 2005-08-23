ad_page_contract {
    List of Serial Numbers.

    @author Joe Cooper (joe@virtualmin.com)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-08-18
} {
    orderby:optional
    owner_id:optional
    software_id:optional
    page:optional
    {page_size "25"}
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ ec-serial-numbers.serial_number_2]"
set context_bar [ad_context_bar $page_title]
set package_id [ad_conn package_id]

set actions [list "[_ ec-serial-numbers.serial_number_New]" serial-number-ae "[_ ec-serial-numbers.serial_number_New2]"]

set orderbys {
    default_value end_date,asc
    owner_name {
	label {[_ ec-serial-numbers.serial_number_owner_id]}
	orderby last_name
	default_direction asc
    }
    end_date {
	label {[_ ec-serial-numbers.serial_number_end_date]} 
	orderby {t.end_date}
	default_direction asc
    }
    title {
	label {[_ ec-serial-numbers.serial_number_Title]}
	orderby title
	default_direction asc
    }
}

set software_options [db_list_of_lists software_options "select product_name,product_id from ec_products where no_shipping_avail_p = 't'"]
set filters {
    owner_id {
	where_clause {t.owner_id = :owner_id}
	default_value ""
    }
    software_id {
	where_clause {t.software_id = :software_id}
	values $software_options
	default_value ""
    }
}

template::list::create \
    -name serial_number \
    -key serial_id \
    -no_data "[_ ec-serial-numbers.None]" \
    -elements {
        title {
	    label {[_ ec-serial-numbers.serial_number_Title]}
	    link_url_eval {[export_vars -base "serial-number-ae" {{serial_id $item_id} {mode display}}]}
        }
	serial_id {
	    label {[_ ec-serial-numbers.serial_number]}
	}
	license_key {
	    label {[_ ec-serial-numbers.serial_number_license_key]}
	}
	start_date {
	    label {[_ ec-serial-numbers.serial_number_start_date]}
	}
	end_date {
	    label {[_ ec-serial-numbers.serial_number_end_date]} 
	}
	owner_name {
	    label {[_ ec-serial-numbers.serial_number_owner_id]}
	}
	product_name {
	    label {[_ ec-serial-numbers.serial_number_software_id]} 
	}
    } -actions $actions \
    -orderby $orderbys \
    -filters $filters \
    -page_size $page_size \
    -page_flush_p 0 \
    -page_query_name serial_number_pagination

db_multirow -extend {edit_link delete_link owner_name product_name} serial_number serial_number {} {
    set edit_link [export_vars -base "serial-number-ae" {{serial_id $item_id}}]
    set delete_link [export_vars -base "serial-number-delete" {{serial_id $item_id}}]
    set owner_name "$first_names $last_name"
    if {[exists_and_not_null software_id]} {
	set product_name [ec_product_name $software_id]
    } else {
	set product_name ""
    }
}

ad_return_template
    
