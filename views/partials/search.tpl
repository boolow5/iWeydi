<div class="col-sm-7 col-sm-offset-2">
  <form id="search-form" method="post" action="/api/search">
    {{ .xsrfdata }}
    <input class="form-control" type="text" name="search" placeholder='{{i18n .Lang "search_text"}}' />
    <button class="btn btn-primary"> <i class="fa fa-lens fa-fw" aria-hidden="true"></i> {{i18n .Lang "search"}}</button>

  </form>
  <div id="search-results">
    Search results
  </div>
</div>
