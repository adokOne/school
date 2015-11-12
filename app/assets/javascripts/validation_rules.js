$.validator.addMethod("alpha", function(value, element) {
    return this.optional(element) || value == value.match(/^[а-яА-Яa-zA-Z\s]+$/);
});
