describe('index page', () => {
  beforeEach(() => {
    cy.visit('')
})

  it('should have Grimm in title', () => {
    cy.get('.tp-title > pb-i18n')
      .contains('Grimm')
  })
})