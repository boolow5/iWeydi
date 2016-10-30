<div class="row">

  {{template "partials/left-sidebar.tpl"}}

  <div class="col-sm-7">
    <h1>{{i18n $.Lang .Title}}</h1>
    <div class="one-item-container">
      <p>{{.Question.Description}}</p>
      <hr/>
      {{if isZeroLen .Answers}}
      <h1>{{i18n $.Lang "answers"}}</h1>
      {{end}}
      {{if isNotZeroLen .Answers}}
      {{range $val, $index := .Answers}}

      <div class="a-item one-item-container">
        <a href="#">
          <img class='a-item-author-img{{if eq .Lang "ar-SA"}}-arabic{{end}}' src="/static/img/author.jpg">
        </a>
        <h3>
          <a href="#">
            Question for this answer?
          </a>
          <div class="a-item-header">
            <a href="#">
              <span class="a-item-author-name">Author Name</span>
              <span class="a-item-author-description">I'm the author of this answer</span>
            </a>
          </div>
        </h3>

        <p>The description of the answer will be layed out here the same as this text you're reading right now... <a href="#">read more!</a></p>
        <span>{{i18n $.Lang "time_before_hours" 12}} </span>
        <span class="counter-item">5 | {{i18n $.Lang "loved_this"}}</span>
        <span class="counter-item">2 | {{i18n $.Lang "hated_this"}}</span>
        <span class="counter-item">10 | {{i18n $.Lang "commented_on_this"}}</span>
      </div>


      {{end}}
      {{end}}
    </div>

  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
