use pyo3::prelude::*;

#[pyclass]
struct SomeClass(i32);

#[pymethods]
impl SomeClass {
    #[new]
    fn new(value: i32) -> Self {
        Self(value)
    }

    fn __bool__(&self) -> bool {
        self.0 != 0
    }

    fn __str__(&self) -> String {
        format!("SomeClass with value {}", self.0)
    }

    fn __repr__(&self) -> String {
        format!("SomeClass({})", self.0)
    }
}

#[pyfunction]
fn hello_world() -> PyResult<String> {
    Ok(String::from("Hello World!"))
}

#[pymodule]
fn _lib(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_class::<SomeClass>()?;
    m.add_function(wrap_pyfunction!(hello_world, m)?)?;

    Ok(())
}
