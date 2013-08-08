class CoursesController < ApplicationController
  def new
    @course = Course.new
    @title = "New Course"
  end

  def create
    # raise params.inspect
    @course = Course.new(params[:course])
    @course.add_starting_date(params[:date])
    @course.save
    redirect_to courses_path
  end

  def index
    redirect_to course_path(Course.where("starting_date >= :today", {today: Date.today}).order(:starting_date).first)
  end

  def show
    @title = "All Courses"
    #for needs decision
    # raise params.inspect
    @dossiers = Dossier.where(:aasm_state => "needs_decision")
    @courses = Course.where("starting_date >= :today", {today: Date.today}).order(:starting_date)
    authorize! :index, @courses

    # if params[:course]
    #   @course = @courses[params[:course].to_i]
    # else
    #   @course = Course.find_by_id(params[:id])
    # end

    @course = Course.find_by_id(params[:id])
    @gender_count = Course.joins(:dossiers).where("courses.id" => @course.id).where("dossiers.gender = ? OR dossiers.gender = ? OR dossiers.gender = ?", "male", "female", "other")
    @male_count = @gender_count.where("dossiers.gender" => "male").count
    @female_count = @gender_count.where("dossiers.gender" => "female").count
    @other_count = @gender_count.where("dossiers.gender" => "other").count

    @passion_one_count = Score.joins(:dossier => :course).where("courses.id" => 1).where("scores.passion" => 1).count
    @passion_two_count = Score.joins(:dossier => :course).where("courses.id" => 1).where("scores.passion" => 2).count
    @passion_three_count = Score.joins(:dossier => :course).where("courses.id" => 1).where("scores.passion" => 3).count
    @passion_four_count = Score.joins(:dossier => :course).where("courses.id" => 1).where("scores.passion" => 4).count
    @passion_five_count = Score.joins(:dossier => :course).where("courses.id" => 1).where("scores.passion" => 5).count

#we have a problem here...
  #you send EITHER params[:course] or params[:hashtag]
  # therefore you are NOT searching the current course, which gets automatically
  #set to course[0] when you refresh it.
    if params[:hashtag]
      if params[:hashtag].empty?
        #to be set correctly,
        #@course should equal its position in the index
        @confirmed = Dossier.joins(:course)
        .where('dossiers.aasm_state = ? or dossiers.aasm_state = ?', "committed", "needs_payment")
        .where('courses.id' => @course.id)
      else
        @confirmed = Dossier.joins(:course)
        .where('dossiers.aasm_state = ? or dossiers.aasm_state = ?', "committed", "needs_payment")
        .where('courses.id' => @course.id).with_hashtag(params[:hashtag])
      end
    else
      @confirmed = Dossier.joins(:course)
      .where('dossiers.aasm_state = ? or dossiers.aasm_state = ?', "committed", "needs_payment")
      .where('courses.id' => @course.id)
    end
  end

  def dashboard
    @title = "Course Dashboard"
    @courses = Course.all
    @course = Course.first

    # gender breakdown data
    @male_count = Course.joins(:dossiers).where("dossiers.gender" => "male").count
    @female_count = Course.joins(:dossiers).where("dossiers.gender" => "female").count
    @other_count = Course.joins(:dossiers).where("dossiers.gender" => "other").count

    # velocity data
    @viewed_today     = Course.count_actions("needs review", "today")
    @viewed_yesterday = Course.count_actions("needs review", "yesterday")

    @reviewed_today     = Course.count_actions "reviewed", "today"
    @reviewed_yesterday = Course.count_actions "reviewed", "yesterday"

    @interviewed_today     = Course.count_actions("needs decision", "today")
    @interviewed_yesterday = Course.count_actions("needs decision", "yesterday")

    @resolved_today     = Course.count_actions "resolved", "today"
    @resolved_yesterday = Course.count_actions "resolved", "yesterday"

  end

end
