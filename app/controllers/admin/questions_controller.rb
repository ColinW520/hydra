class Admin::QuestionsController < Admin::BaseController
  before_filter :find_question, except: [:index, :new, :create, :list]

  def index
    questions_scope = Question.rank(:display_order).all

    respond_to do |format|
      format.html {
        smart_listing_create :questions, questions_scope, partial: 'admin/questions/listing', default_sort: { display_order: :asc }
      }
      format.js { smart_listing_create :questions, questions_scope, partial: 'admin/questions/listing', default_sort: { display_order: :asc } }
    end
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    respond_to do |format|
      if @question.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Question has been created.' }
        format.html {
          flash[:success] = 'Question has been created.'
          redirect_to admin_questions_path
        }
      else
        format.json { render json: @question.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
  end

  def edit

  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html {
          flash[:sucess] = 'Question has been updated!'
          redirect_to admin_questions_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Question has been updated.' }
      else
        format.json { render json: @question.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @question.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update_row_order
    @question.display_order_position = params[:display_order_position]
    @question.save!

    head :ok # this is a POST action, updates sent via AJAX, no view rendered
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Question removed.' }
      format.html { redirect_to admin_questions_path, notice: 'Question removed.' }
      format.json { head :no_content }
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit!
  end
end
