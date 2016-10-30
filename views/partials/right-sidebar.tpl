<div class="col-sm-3">
  <h4>Right Side bar</h4>
  {{if .NotLoggedIn }}
  <h1>{{i18n $.Lang "login"}}</h1>
  <div class="list-item-container q-list">
    <form id="login-form" class="form" method="post" action="/user/login">
      {{ .xsrfdata }}
      <div class="input-group">
        <input type="text" class="form-control" name="email" placeholder='{{i18n .Lang "email"}}' id="login-email">
        <input type="password" class="form-control" name="password" placeholder='{{i18n .Lang "password"}}' id="login-email">
      </div>
      <button class="btn btn-primary" id="login-user-btn">{{i18n .Lang "login_btn"}}</button>
    </form>

  </div>
  {{end}}
</div>
