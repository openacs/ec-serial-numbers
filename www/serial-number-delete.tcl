ad_page_contract {
    Delete Serial Number.

    @author Joe Cooper (joe@virtualmin.com)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-08-18
} {
    serial_id
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ ec-serial-numbers.serial_number_Delete]"
set context_bar [ad_context_bar [list "serial-number-list" "[_ ec-serial-numbers.serial_number_2]"] $page_title]

set confirm_options [list [list "[_ ec-serial-numbers.continue_with_delete]" t] [list "[_ ec-serial-numbers.cancel_and_return]" f]]

ad_form -name delete_confirm -action serial-number-delete -export { serial_id } -form {
    {section_id:key}
    {title:text(inform) {label "[_ ec-serial-numbers.Delete]"}}
    {confirmation:text(radio) {label " "} {options $confirm_options} {value f}}
} -select_query_name {title} \
-on_submit {
    if {$confirmation} {
	db_dml mark_deleted {}
    }
} -after_submit {
    ad_returnredirect "serial-number-list"
    ad_script_abort
}

ad_return_template
    
