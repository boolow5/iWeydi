<div class="row">

  {{template "partials/left-sidebar.tpl"}}



  <div class="col-sm-7">
    <br>
    <h1>{{i18n $.Lang "register"}}</h1>
    <div class="list-item-container q-list">
      <form class="form" method="post" action="/api/user/login">
        <div class="input-group">
          <input type="text" class="form-control" name="first_name" placeholder='{{i18n .Lang "first_name"}}' id="register-first_name">
          <input type="text" class="form-control" name="last_name" placeholder='{{i18n .Lang "last_name"}}' id="register-last_name">
          
          <input type="password" class="form-control" name="password" placeholder='{{i18n .Lang "password"}}' id="login-email">
        </div>
      </form>
      <button class="btn btn-primary" id="login-user-btn">{{i18n .Lang "finish"}}</button>
    </div>

    <br>


  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
