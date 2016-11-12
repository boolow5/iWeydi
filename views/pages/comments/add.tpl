<form class="comment-form" method="post" action="/api/comment">
  {{ .xsrfdata }}
  <textarea class="textwrapper" name="text" placeholder='{{i18n .Lang "enter_comment_here"}}' rows="3" id="comment-text-editor"></textarea>
  <button class="btn btn-primary" id="add-new-comment-btn">{{i18n .Lang "save"}}</button>
</form>
