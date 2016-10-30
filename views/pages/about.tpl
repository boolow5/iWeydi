<div class="row">

  {{template "partials/left-sidebar.tpl"}}



  <div class="col-sm-7">
    <h1>{{i18n $.Lang "about"}}</h1>
    <p>{{i18n $.Lang "app_description"}}</p>

    <br>
    <h1>{{i18n $.Lang "questions"}}</h1>
    <div class="list-item-container q-list">
      <div class="one-item-container q-item">
        <h3><a href="#">What did you asked in this question?</a></h3>
        <p>The description of the question you asked will be layed out here the same as this text you're reading right now.</p>
        <span>{{i18n $.Lang "time_before_hours" 1 }} </span>
        <span class="counter-item">5 | {{i18n $.Lang "loved_this"}}</span>
        <span class="counter-item">2 | {{i18n $.Lang "hated_this"}}</span>
        <span class="counter-item">10 | {{i18n $.Lang "commented_on_this"}}</span>
      </div>
      <div class="one-item-container q-item">
        <h3><a href="#">What did you asked in this question?</a></h3>
        <p>The description of the question you asked will be layed out here the same as this text you're reading right now.</p>
        <span>{{i18n $.Lang "time_before_hours" 5 }} </span>
        <span class="counter-item">5 | {{i18n $.Lang "loved_this"}}</span>
        <span class="counter-item">2 | {{i18n $.Lang "hated_this"}}</span>
        <span class="counter-item">10 | {{i18n $.Lang "commented_on_this"}}</span>
      </div>
      <div class="one-item-container q-item">
        <h3><a href="#">What did you asked in this question?</a></h3>
        <p>The description of the question you asked will be layed out here the same as this text you're reading right now.</p>
        <span>{{i18n $.Lang "time_before_hours" 2}} </span>
        <span class="counter-item">5 | {{i18n $.Lang "loved_this"}}</span>
        <span class="counter-item">2 | {{i18n $.Lang "hated_this"}}</span>
        <span class="counter-item">10 | {{i18n $.Lang "commented_on_this"}}</span>
      </div>
    </div>

    <h1>{{i18n $.Lang "answers"}}</h1>
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

    <br>


  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
