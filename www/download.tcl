ad_page_contract {
    List of Serial Numbers.

    @author Joe Cooper (joe@virtualmin.com)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-08-18
} {
    serial_id
    software_id:optional
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ ec-serial-numbers.serial_number_2]"
set context_bar [ad_context_bar $page_title]
set package_id [ad_conn package_id]

# If we have a software_id (which corresponds to the product_id of the ecommerce produkt
# that resembles the software), look if we have a special installer file for that product.
# Otherwise use the default installer file. You could use any other file as well.

set path "/web/devel/packages/ec-serial-numbers/templates"
if {[exists_and_not_null software_id] && [file exists "$path/install-${software_id}.sh"]} {
    set file_name "/web/devel/packages/ec-serial-numbers/templates/install-${software_id}.sh"
} else {
    set file_name "/web/devel/packages/ec-serial-numbers/templates/install.sh"
}

# Admins can get license keys from any user.
set user_id [ad_conn user_id]
set admin_p [acs_user::site_wide_admin_p -user_id $user_id]

if {$admin_p} {
    set user_where_clause ""
} else {
    set user_where_clause "and owner_id = :user_id"
}

if {[db_0or1row get_key "select license_key from ec_serial_numbers esn, cr_items ci where ci.item_id = :serial_id and ci.latest_revision = esn.serial_id $user_where_clause"]} {

    set file [open $file_name]
    fconfigure $file -translation binary
    set __the_body__ [read $file]
    set __the_body__ [encoding convertfrom utf-8 $__the_body__] 
    close $file

    regsub {@KEY@} $__the_body__ $license_key body
    regsub {@SERIAL@} $body $serial_id body
    ns_set put [ad_conn outputheaders] Content-Disposition "attachment;filename=install.sh"
    ns_return 200 "text/plain" "$body"    
} else {
    ad_return_error "No such serial number" "We are sorry but we don't have the serial number on record"
}