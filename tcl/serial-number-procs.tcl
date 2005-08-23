ad_library {
    Serial Number procs
    @author Joe Cooper (joe@virtualmin.com)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-08-18
}

namespace eval sc-sn::serial_number {}

ad_proc -public sc-sn::serial_number::new {
    {-name ""}
    {-title ""}
    {-description ""}
    {-package_id ""}
    {-license_key ""}
    {-start_date ""}
    {-end_date ""}
    {-owner_id ""}
    {-software_id ""}
} {
    @author Joe Cooper (joe@virtualmin.com)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-08-18

    New Serial Number
} {
    if {[empty_string_p $package_id]} {
	set package_id [ad_conn package_id]
    }
    set folder_id [sc-sn::util::folder_id -package_id $package_id]

    db_transaction {
	if {[empty_string_p $name]} {
	    set name [exec uuidgen]
	}
	set item_id [content::item::new -parent_id $folder_id -content_type {serial_number} -name $name -title $title]

	set new_id [content::revision::new \
		       -item_id $item_id \
		       -content_type {serial_number} \
		       -title $title \
		       -description $description \
		       -attributes [list \
		[list license_key $license_key] \
		[list start_date $start_date] \
		[list end_date $end_date] \
		[list owner_id $owner_id] \
		[list software_id $software_id] ] ]
    }

    return $new_id
}

ad_proc -public sc-sn::serial_number::edit {
    -serial_id:required
    {-title ""}
    {-description ""}
    {-license_key ""}
    {-start_date ""}
    {-end_date ""}
    {-owner_id ""}
    {-software_id ""}
} {
    @author Joe Cooper (joe@virtualmin.com)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-08-18

    Edit Serial Number
} {
    db_transaction {
	set new_rev_id [content::revision::new \
			    -item_id $serial_id \
			    -content_type {serial_number} \
			    -title $title \
			    -description $description \
			    -attributes [list \
		[list license_key $license_key] \
		[list start_date $start_date] \
		[list end_date $end_date] \
		[list owner_id $owner_id] \
		[list software_id $software_id] ] ]
    }

    return $new_rev_id
}
    
