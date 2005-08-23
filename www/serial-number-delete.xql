<?xml version="1.0"?>
<queryset>

<fullquery name="title">
      <querytext>

	select title
	from cr_revisions
	where revision_id = :serial_id

      </querytext>
</fullquery>

<fullquery name="mark_deleted">
      <querytext>

	update cr_items
	set latest_revision = null
	where latest_revision = :serial_id

      </querytext>
</fullquery>

</queryset>
    
