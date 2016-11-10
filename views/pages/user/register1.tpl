<div class="row">

  {{template "partials/left-sidebar.tpl"}}



  <div class="col-sm-7">
    <br>
    <h1>{{i18n $.Lang "register"}}</h1>
    <div class="list-item-container q-list">
      <form id="register-form" class="form" method="post" action="/user/register">
        <div class="input-group">
          <input type="text" class="form-control" name="first_name" placeholder='{{i18n .Lang "first_name"}}' id="register-first_name" autofocus>
          <input type="text" class="form-control" name="last_name" placeholder='{{i18n .Lang "last_name"}}' id="register-last_name">

          <input type="text" class="form-control" name="email" placeholder='{{i18n .Lang "email"}}' id="login-email">
          <input type="password" class="form-control" name="password" placeholder='{{i18n .Lang "password"}}' id="login-email">
        </div>
        <button class="btn btn-primary" id="register-user-btn">{{i18n .Lang "save"}}</button>
      </form>

    </div>

    <br>


  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
