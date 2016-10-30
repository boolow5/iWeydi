<div class="row">

  {{template "partials/left-sidebar.tpl"}}

  <div class="col-sm-7">
    <h1>{{i18n $.Lang .Title}}</h1>
    <div class="one-item-container q-list">
      <form id="question-form" class="form" method="post" action="/api/question">
        <div class="input-group">
          <span class='input-group-addon{{if eq .Lang "ar-SA"}} horizontal-mirror{{end}}' id="basic-addon1">?</span>
          <input type="text" class="form-control form-control-arabic" name="text" placeholder='{{i18n .Lang "enter_question_here"}}' id="question-text-editor" aria-describedby="basic-addon1">
          <input type="text" class="form-control form-control-arabic" name="description" placeholder='{{i18n .Lang "enter_description_here"}}' id="question-text-editor" aria-describedby="basic-addon1">
        </div>
        <br>
        <button class="btn btn-primary" id="add-new-question-btn">{{i18n .Lang "save"}}</button>
      </form>
    </div>
  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
