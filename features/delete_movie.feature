Feature: delete a movie from the site that has previously been added
  As a user
  So that I can manage the collection of movies
  I want to be able to remove movies

Background: movies have been added to database

  Given the following movies exist:
  | title                   | rating | release_date |
  | Aladdin                 | G      | 25-Nov-1992  |
  | The Terminator          | R      | 26-Oct-1984  |
  | When Harry Met Sally    | R      | 21-Jul-1989  |

  And  I am on the RottenPotatoes home page

Scenario: delete a movie
  Given I am on the details page for "Aladdin"
  When I press "Delete"
  Then I should be on the RottenPotatoes home page
  And I should see "'Aladdin' deleted"
  And I should not see "More about Aladdin"
