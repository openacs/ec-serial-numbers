ad_page_contract {
    Form to add/edit Serial Number.

    @author Joe Cooper (joe@virtualmin.com)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-08-18
} {
    serial_id:integer,optional
    {__new_p 0}
    {mode edit}
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set has_submit 0
if {![info exists serial_id] || $__new_p} {
    set page_title "[_ ec-serial-numbers.serial_number_Add]"
    set _serial_id 0
} else {
    if {$mode == "edit"} {
        set page_title "[_ ec-serial-numbers.serial_number_Edit]"
    } else {
        set page_title "[_ ec-serial-numbers.serial_number_View]"
        set has_submit 1
    }
    set _serial_id $serial_id
}

set context_bar [ad_context_bar [list "serial-number-list" "[_ ec-serial-numbers.serial_number_2]"] $page_title]
set package_id [ad_conn package_id]

set owner_id_options [list]
set software_id_options [list]

ad_form -name serial_number_form -action serial-number-ae -mode $mode -has_submit $has_submit -form {
    {serial_id:key}
}
    
ad_form -extend -name serial_number_form -form {
    {title:text {label "[_ ec-serial-numbers.serial_number_Title]"} {html {size 80 maxlength 1000}} {help_text "[_ ec-serial-numbers.serial_number_Title_help]"}}
}
	
if {![empty_string_p [category_tree::get_mapped_trees $package_id]]} {
    category::ad_form::add_widgets -container_object_id $package_id -categorized_object_id $_serial_id -form_name serial_number_form
}

ad_form -extend -name serial_number_form -form {
	{license_key:text {label "[_ ec-serial-numbers.serial_number_license_key]"} {html {size 80 maxlength 200}} {help_text "[_ ec-serial-numbers.serial_number_license_key_help]"}}
	{start_date:date(date),to_sql(ansi),from_sql(ansi) {label "[_ ec-serial-numbers.serial_number_start_date]"}  {help_text "[_ ec-serial-numbers.serial_number_start_date_help]"}}
	{end_date:date(date),to_sql(ansi),from_sql(ansi) {label "[_ ec-serial-numbers.serial_number_end_date]"}  {help_text "[_ ec-serial-numbers.serial_number_end_date_help]"}}
	{owner_id:text(inform) {label "[_ ec-serial-numbers.serial_number_owner_id]"} {options $owner_id_options} {help_text "[_ ec-serial-numbers.serial_number_owner_id_help]"}}
	{software_id:text(inform) {label "[_ ec-serial-numbers.serial_number_software_id]"} {options $software_id_options} {help_text "[_ ec-serial-numbers.serial_number_software_id_help]"}}
} -new_request {
    set title ""
	set license_key ""
	set start_date ""
	set end_date ""
	set owner_id ""
	set software_id ""
} -edit_request {
    db_1row get_data {}
} -on_submit {
    set category_ids [category::ad_form::get_categories -container_object_id $package_id]
} -new_data {
    db_transaction {
	set new_serial_id [sc-sn::serial_number::new  \
		-title $title  \
		-license_key $license_key \
		-start_date $start_date \
		-end_date $end_date \
		-owner_id $owner_id \
		-software_id $software_id ]

	if {[exists_and_not_null category_ids]} {
	    category::map_object -object_id $new_serial_id $category_ids
	}
    }
} -edit_data {
    db_transaction {
	set new_serial_id [sc-sn::serial_number::edit \
				-serial_id $serial_id \
		-title $title  \
		-license_key $license_key \
		-start_date $start_date \
		-end_date $end_date \
		-owner_id $owner_id \
		-software_id $software_id ]

	if {[exists_and_not_null category_ids]} {
	    category::map_object -object_id $new_serial_id $category_ids
	}
    }
} -after_submit {
    ad_returnredirect serial-number-list
    ad_script_abort
}

ad_return_template
    
