require 'rails_helper'

include Surveymonkey

RSpec.describe ResponseDetails do
  describe '.fetch' do
  end

  describe '#answer_by_scheme' do
    it "returns nil if page is not found" do
      response_details = ResponseDetails.new({
                                               pages: []
                                             })
      scheme = Mapping::Scheme.new({
                                     name: "email",
                                     page_id: "150541761",
                                     question_id: "588749040",
                                     type: "text"
                                   })
      answer = response_details.answer_by_scheme(scheme)
      expect(answer).to eq({ email: nil })

      response_details = ResponseDetails.new({
                                               pages: [
                                                 {
                                                   id: "1",
                                                   questions: []
                                                 }
                                               ]
                                             })
      scheme = Mapping::Scheme.new({
                                     name: "email",
                                     page_id: "2",
                                     question_id: "1",
                                     type: "text"
                                   })
      answer = response_details.answer_by_scheme(scheme)
      expect(answer).to eq({ email: nil })
    end

    it "returns nil if question is not found" do
      response_details = ResponseDetails.new({
                                               pages: [
                                                 {
                                                   id: "1",
                                                   questions: []
                                                 }
                                               ]
                                             })
      scheme = Mapping::Scheme.new({
                                     name: "email",
                                     page_id: "150541761",
                                     question_id: "588749040",
                                     type: "text"
                                   })
      answer = response_details.answer_by_scheme(scheme)
      expect(answer).to eq({ email: nil })

      response_details = ResponseDetails.new({
                                               pages: [
                                                 {
                                                   id: "1",
                                                   questions: [{
                                                                 id: "123"
                                                               }]
                                                 }
                                               ]
                                             })
      scheme = Mapping::Scheme.new({
                                     name: "email",
                                     page_id: "2",
                                     question_id: "1",
                                     type: "text"
                                   })
      answer = response_details.answer_by_scheme(scheme)
      expect(answer).to eq({ email: nil })
    end

    it "returns nil if answer is not found" do
      response_details = ResponseDetails.new({
                                               pages: [
                                                 {
                                                   id: "1",
                                                   questions: [{
                                                                 id: "2",
                                                                 answers: []
                                                               }]
                                                 }
                                               ]
                                             })

      scheme = Mapping::Scheme.new({
                                     name: "email",
                                     page_id: "1",
                                     question_id: "2",
                                     type: "text"
                                   })
      answer = response_details.answer_by_scheme(scheme)
      expect(answer).to eq({ email: nil })
    end

    it "returns nil if type is invalid" do
      response_details = ResponseDetails.new({
                                               pages: [
                                                 {
                                                   id: "1",
                                                   questions: [{
                                                                 id: "2",
                                                                 answers: [{
                                                                             text: "john@email.com"
                                                                           }]
                                                               }]
                                                 }
                                               ]
                                             })

      scheme = Mapping::Scheme.new({
                                     name: "email",
                                     page_id: "1",
                                     question_id: "2",
                                     type: "wrong"
                                   })
      answer = response_details.answer_by_scheme(scheme)
      expect(answer).to eq({ email: nil })
    end

    it "returns nil if row is not found" do
      response_details = ResponseDetails.new({
                                               pages: [
                                                 {
                                                   id: "1",
                                                   questions: [{
                                                                 id: "2",
                                                                 answers: [{
                                                                             row_id: "5",
                                                                             text: "john@email.com"
                                                                           }]
                                                               }]
                                                 }
                                               ]
                                             })

      scheme = Mapping::Scheme.new({
                                     name: "email",
                                     page_id: "1",
                                     question_id: "2",
                                     type: "contacts",
                                     params: {
                                       row_id: "2",
                                     }
                                   })
      answer = response_details.answer_by_scheme(scheme)
      expect(answer).to eq({ email: nil })
    end

    it "returns answer value of 'text' type" do
      response_details = ResponseDetails.new({
                                               pages: [
                                                 {
                                                   id: "150541761",
                                                   questions: [
                                                     {
                                                       id: "588749040",
                                                       answers: [
                                                         {
                                                           text: "john@email.com"
                                                         }
                                                       ]
                                                     },
                                                     {
                                                       id: "868749040",
                                                       answers: [
                                                         {
                                                           text: "John"
                                                         }
                                                       ]
                                                     }
                                                   ]
                                                 },
                                                 {
                                                   id: "170256237",
                                                   questions: [
                                                     {
                                                       id: "836485729",
                                                       answers: [
                                                         {
                                                           text: "+1 111 222 1234"
                                                         }
                                                       ]
                                                     },
                                                   ]
                                                 }
                                               ]
                                             })
      scheme = Mapping::Scheme.new({
                                     name: "email",
                                     page_id: "150541761",
                                     question_id: "588749040",
                                     type: "text"
                                   })
      answer = response_details.answer_by_scheme(scheme)
      expect(answer).to eq({ email: "john@email.com" })

      scheme = Mapping::Scheme.new({
                                     name: "name",
                                     page_id: "150541761",
                                     question_id: "868749040",
                                     type: "text"
                                   })
      answer = response_details.answer_by_scheme(scheme)
      expect(answer).to eq({ name: "John" })

      scheme = Mapping::Scheme.new({
                                     name: "phone",
                                     page_id: "170256237",
                                     question_id: "836485729",
                                     type: "text"
                                   })
      answer = response_details.answer_by_scheme(scheme)
      expect(answer).to eq({ phone: "+1 111 222 1234" })
    end

    it "returns answer value of 'contacts' type" do
      response_details = ResponseDetails.new({
                                               pages: [
                                                 {
                                                   id: "150541761",
                                                   questions: [
                                                     {
                                                       id: "588749040",
                                                       answers: [
                                                         {
                                                           row_id: "3885934603",
                                                           text: "john@email.com"
                                                         },
                                                         {
                                                           row_id: "3885934595",
                                                           text: "John"
                                                         }
                                                       ]
                                                     }
                                                   ]
                                                 }
                                               ]
                                             })
      scheme = Mapping::Scheme.new({
                                     name: "email",
                                     page_id: "150541761",
                                     question_id: "588749040",
                                     type: "contacts",
                                     params: {
                                       row_id: "3885934603"
                                     }
                                   })
      answer = response_details.answer_by_scheme(scheme)
      expect(answer).to eq({ email: "john@email.com" })

      scheme = Mapping::Scheme.new({
                                     name: "name",
                                     page_id: "150541761",
                                     question_id: "588749040",
                                     type: "contacts",
                                     params: {
                                       row_id: "3885934595"
                                     }
                                   })
      answer = response_details.answer_by_scheme(scheme)
      expect(answer).to eq({ name: "John" })
    end
  end

  it "returns answer value of 'single_choice' type" do
    response_details = ResponseDetails.new({
                                             pages: [
                                               {
                                                 id: "150541761",
                                                 questions: [
                                                   {
                                                     id: "588749040",
                                                     answers: [
                                                       {
                                                         choice_id: "3885934603"
                                                       }
                                                     ]
                                                   },
                                                   {
                                                    id: "588749041",
                                                    answers: [
                                                      {
                                                        other_id: "3885934605",
                                                        text: "Bar"
                                                      }
                                                    ]
                                                  }
                                                 ]
                                               }
                                             ]
                                           })
    scheme = Mapping::Scheme.new({
                                   name: "role",
                                   page_id: "150541761",
                                   question_id: "588749040",
                                   type: "single_choice",
                                   params: {
                                     choices: {
                                       "3885934603".to_sym => "Foo"
                                     }
                                   }
                                 })
    answer = response_details.answer_by_scheme(scheme)
    expect(answer).to eq({ role: "Foo" })

    scheme = Mapping::Scheme.new({
                                   name: "role",
                                   page_id: "150541761",
                                   question_id: "588749040",
                                   type: "single_choice",
                                   params: {
                                     choices: {
                                       "3885934604".to_sym => "Foo"
                                     }
                                   }
                                 })
    answer = response_details.answer_by_scheme(scheme)
    expect(answer).to eq({ role: nil })

    scheme = Mapping::Scheme.new({
                                   name: "role",
                                   page_id: "150541761",
                                   question_id: "588749041",
                                   type: "single_choice",
                                   params: {
                                    choices: {
                                      "3885934605".to_sym => "Other"
                                    }
                                   }
                                 })
    answer = response_details.answer_by_scheme(scheme)
    expect(answer).to eq({ role: 'Other' })
  end

  describe '#answers_by_mapping' do
    it "returns answers object according to mapping" do
      response_details = ResponseDetails.new({
                                               pages: [
                                                 {
                                                   id: "150541761",
                                                   questions: [
                                                     {
                                                       id: "588749040",
                                                       answers: [
                                                         {
                                                           row_id: "3885934603",
                                                           text: "john@email.com"
                                                         },
                                                         {
                                                           row_id: "3885934595",
                                                           text: "John"
                                                         }
                                                       ]
                                                     }
                                                   ]
                                                 },
                                                 {
                                                   id: "170256237",
                                                   questions: [
                                                     {
                                                       id: "836485729",
                                                       answers: [
                                                         {
                                                           text: "+1 111 222 1234"
                                                         }
                                                       ]
                                                     },
                                                   ]
                                                 }
                                               ]
                                             })
      mapping = Mapping.new([
                              Mapping::Scheme.new({
                                                    name: "email",
                                                    page_id: "150541761",
                                                    question_id: "588749040",
                                                    type: "contacts",
                                                    params: {
                                                      row_id: "3885934603"
                                                    }
                                                  }),
                              Mapping::Scheme.new({
                                                    name: "name",
                                                    page_id: "150541761",
                                                    question_id: "588749040",
                                                    type: "contacts",
                                                    params: {
                                                      row_id: "3885934595"
                                                    }
                                                  }),
                              Mapping::Scheme.new({
                                                    name: "phone",
                                                    page_id: "170256237",
                                                    question_id: "836485729",
                                                    type: "text",
                                                  })
                            ])
      answers = response_details.answers_by_mapping(mapping)
      expect(answers).to eq({
                              email: "john@email.com",
                              name: "John",
                              phone: "+1 111 222 1234"
                            })
    end
  end
end