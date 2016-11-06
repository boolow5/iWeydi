<div class="row">
  {{template "partials/left-sidebar.tpl"}}

  <h1>{{i18n $.Lang "profile"}}</h1>
  <div class="col-sm-7 container profile-container">
    <div class="row">
      <div class="col-sm-4 right-half">
        <img class="img-responsive" src="/static/img/author.jpg">
      </div>
      <div class="col-sm-8 left-half">
        <h4>{{.FullName}}</h4>
        <ul>
          <li>
            Knows:
            <ol class="list-unstyled">
              <li class="knows-li">Programming</li>
              <li class="knows-li">Web development</li>
              <li class="knows-li">Database Management</li>
            </ol>
          </li>

        </ul>
      </div>
    </div>
  </div>

  {{template "partials/right-sidebar.tpl"}}
</div>
