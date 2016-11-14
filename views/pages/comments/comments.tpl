<ul class="comments-ul list-unstyled">
  {{range $index, $val := .Comments}}
    <li class="comment-li">
      <div class="one-comment">
        <p>
          <span class="grayish-color"><i class="fa fa-comment-o fa-fw" aria-hidden="true"></i></span>
          {{$val.text | markdown}}
        </p>
        <p class="comment-toolbar">
          <i class="fa fa-user fa-fw" aria-hidden="true"></i> {{$val.author_name}}
          <i class="fa fa-clock-o fa-fw" aria-hidden="true"></i> {{$val.created_at}}
          <i class="fa fa-thumbs-o-up fa-fw" aria-hidden="true"></i> {{$val.love_count}}
          <i class="fa fa-thumbs-o-down fa-fw" aria-hidden="true"></i> {{$val.hate_count}}
        </p>
      </div>
    </li>
  {{end}}
</ul>
