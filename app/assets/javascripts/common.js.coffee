
$ ->
  $('.country_with_autocomplete').typeahead
    name: "country"
    remote: $('.country_with_autocomplete').data('autocompleteurl')+'?country=%QUERY'


$ ->
  $('.organization_with_autocomplete').typeahead
    name: "organization"
    remote: 
      url: $('.organization_with_autocomplete').data('autocompleteurl')+'?organization=%QUERY'
      replace: (url, uriEncodedQuery) ->

        url = $('.organization_with_autocomplete').data('autocompleteurl')

        val_country = $(".country_with_autocomplete").val()
        return url  unless val_country

        val_organization = $(".organization_with_autocomplete").val()
        return url  unless val_organization

        url + '?country=' + encodeURIComponent(val_country) + "&organization=" + encodeURIComponent(val_organization) 

$ ->
  $('.department_with_autocomplete').typeahead
    name: "department"
    remote: 
      url: $('.department_with_autocomplete').data('autocompleteurl')+'?department=%QUERY'
      replace: (url, uriEncodedQuery) ->

        url = $('.department_with_autocomplete').data('autocompleteurl')

        val_country = $(".country_with_autocomplete").val()
        return url  unless val_country

        val_organization = $(".organization_with_autocomplete").val()
        return url  unless val_organization

        val_department = $(".department_with_autocomplete").val()
        return url  unless val_department

        url + '?country=' + encodeURIComponent(val_country) + "&organization=" + encodeURIComponent(val_organization)+"&department=" + encodeURIComponent(val_department)

$ ->
  $('.group_with_autocomplete').typeahead
    name: "group"
    remote: 
      url: $('.group_with_autocomplete').data('autocompleteurl')+'?group=%QUERY'
      replace: (url, uriEncodedQuery) ->

        url = $('.group_with_autocomplete').data('autocompleteurl')

        val_country = $(".country_with_autocomplete").val()
        return url  unless val_country

        val_organization = $(".organization_with_autocomplete").val()
        return url  unless val_organization

        val_department = $(".department_with_autocomplete").val()
        return url  unless val_department

        val_group = $(".organization_with_autocomplete").val()
        return url  unless val_group

        url+'?country='+encodeURIComponent(val_country)+"&organization="+encodeURIComponent(val_organization)+"&department="+encodeURIComponent(val_department)+"&group="+encodeURIComponent(val_group)