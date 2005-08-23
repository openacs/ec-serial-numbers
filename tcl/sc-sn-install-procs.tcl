ad_library {
    Ecommerce Serial Number Tracking Package install callbacks
    
    Procedures that deal with installing.
    
    @author Joe Cooper (joe@virtualmin.com)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-08-18
}

namespace eval sc-sn::install {}

ad_proc -public sc-sn::install::create_install {
} {
    Creates the content types and adds the attributes.
} {
    content::type::new -content_type {serial_number} -supertype {content_revision} -pretty_name {Serial Number} -pretty_plural {Serial Numbers} -table_name {ec_serial_numbers} -id_column {serial_id}

# Serial Number
content::type::attribute::new -content_type {serial_number} -attribute_name {license_key} -datatype {string} -pretty_name {License Key} -column_spec {varchar(100)}
content::type::attribute::new -content_type {serial_number} -attribute_name {start_date} -datatype {date} -pretty_name {Start Date} -column_spec {date}
content::type::attribute::new -content_type {serial_number} -attribute_name {end_date} -datatype {date} -pretty_name {Expiration Date} -column_spec {date}
content::type::attribute::new -content_type {serial_number} -attribute_name {owner_id} -datatype {string} -pretty_name {Owner} -column_spec {integer references users(user_id)}
content::type::attribute::new -content_type {serial_number} -attribute_name {software_id} -datatype {string} -pretty_name {Software} -column_spec {integer references ec_products(product_id)}

}

ad_proc -public sc-sn::install::package_instantiate {
    -package_id:required
} {
    Define folders
} {
    # create a content folder
    set folder_id [content::folder::new -name "ec_serial_numbers_$package_id" -package_id $package_id]
    # register the allowed content types for a folder
    content::folder::register_content_type -folder_id $folder_id -content_type {serial_number} -include_subtypes t
}
