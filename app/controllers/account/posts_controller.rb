class Account::PostsController < ApplicationController
  before_action :authenticate_user!

  before_action :find_post_and_course
  before_action :check_enrolled_status

  def show
    @chapter = Chapter.find(params[:chapter_id])

    set_breadcrumbs

    if @post.is_hidden? || @chapter.is_hidden?
      flash[:warning] = "The content is archived"
      redirect_to root_path
    end

    drop_breadcrumb @chapter.chapter
    drop_breadcrumb @post.title
  end

  def prev
    post = @post.may_prev? || @post
    redirect_to account_chapter_post_path(post.chapter, post)
  end

  def next
    post = @post.may_next? || @post
    redirect_to account_chapter_post_path(post.chapter, post)
  end

  protected

  def find_post_and_course
    @post = Post.find(params[:id])
    @course = @post.course
  end

  def check_enrolled_status
    unless current_user.enrolled_courses.include?(@course)
      flash[:alert] = "您尚未报名此课程"
      redirect_to enroll_course_path(@course)
    end
  end

  def set_breadcrumbs
    @breadcrumbs = [view_context.link_to(@course.title, account_courses_path)]
  end

  def drop_breadcrumb(title = nil, url = nil)
    title ||= @page_title

    if title && url
      @breadcrumbs.push("<a href='#{url}'>#{title}</a>".html_safe)
    elsif title
      @breadcrumbs.push(title.to_s.html_safe)
    end
  end
end
