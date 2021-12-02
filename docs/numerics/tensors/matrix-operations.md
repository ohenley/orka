# Matrix operations

2-D tensors, or matrices, have a few special operations that can be
applied to them.

## Matrix multiplication

The `*` operator is used to perform matrix multiplication on matrices
and vectors. Matrix multiplication is useful to apply transformations
to points (vectors). For example, `:::ada A * B * X` transforms `X`
by `B` to B **x** and then multiplies with `A` to transform it to the
result A B **x**.

!!! tip
    It is more efficient to compute `:::ada A * (B * X)` than
    `:::ada A * B * X` if `X` is a column. This is because the latter
    will perform one matrix-matrix and one matrix-vector multiplication,
    while the former will perform two matrix-vector multiplications, but
    zero matrix-matrix multiplications.

!!! warning "Use function `Multiply` for element-wise multiplication"

!!! summary
    Matrix multiplication is associative and distributive:

    - `:::ada A * (B * C) = (A * B) * C`

    - `:::ada A * (B + C) = A * B + A * C` (similar for `:::ada (B + C) * A`)

!!! warning "Matrix multiplication is not commutative"
    Matrix multiplication is not commutative: `:::ada A * B /= B * A`.

## Matrix power and inverse

If the left operand of the operator `**` is a tensor and the right operand
an `Integer`, then the operator will perform the matrix power. That is,
`:::ada A ** K` where `A` is a tensor, will multiply the matrix `A` with
itself `K` times. For example, `:::ada A ** 3 = A * A * A`.

Note that matrix `A` must be square. `:::ada A ** 0` is equal to the
identity matrix and `:::ada A ** (-1)` is equal to the inverse of `A`.
Any `K` lower than -1 will first compute the inverse of `A` and then
raise that to the power of the absolute value of `K`.

Alternatively, the function `Inverse` will perform `:::ada A ** (-1)`.

!!! warning "An exception is raised if the matrix is not invertible"
    If a matrix `A` is singular, the inverse does not exist and function
    `Inverse` or the `**` operator will raise the exception `Singular_Matrix`.

!!! note
    A **x** = **b** can be solved for **x** with A^-1^ **b**, but it is
    more efficient and accurate to use function `Solve`.

!!! summary
    The inverse of `:::ada A * B` is equal to the product of the
    inverses in the reverse order:
    `:::ada (A * B).Inverse = B.Inverse * A.Inverse`.

    The inverse of an invertible matrix `A` is also invertible:

    - `:::ada A.Inverse.Inverse = A`

## Transpose

The function `Transpose` returns the transpose of a 2-D tensor; the columns
become the rows and the rows become the columns.

For example, given a 2 x 3 matrix `Tensor` containing the following elements:

```
array([[ 1.0, 2.0, 3.0],
       [ 4.0, 5.0, 6.0]])
```

The image of the transpose `:::ada Tensor.Transpose` will print:

```
array([[ 1.0, 4.0],
       [ 2.0, 5.0],
       [ 3.0, 6.0]])
```

!!! summary
    The transpose of `:::ada A * B` is equal to the product of the
    transposes in the reverse order:
    `:::ada (A * B).Transpose = B.Transpose * A.Transpose`.

    Other properties that apply are:

    - `:::ada A.Transpose.Transpose = A`

    - `:::ada (A + B).Transpose = A.Transpose + B.Transpose`

## Outer product

The outer product of two vectors, 1-D tensors, returned by the function
`Outer`, is a matrix, a 2-D tensor. The number of rows is equal to the
size of the first vector and the number of columns is equal to the size
of the second vector.

!!! info "The difference between the outer and inner products"
    The outer product for two vectors **u** and **v** is defined as
    **u** **v**^T^ and is a *n* x *m* matrix, while the inner product
    (or dot product) is defined as **u**^T^ **v** is a 1 x 1 matrix.

## Solving A **x** = **b**

A system of linear equations can be solved by row reducing the augmented
matrix [A **b**] to [I **x**], where I is the identity matrix.
The function `Solve` is given two tensors `A` and `B` and solves A **x** = **b**
for each vector **b** in tensor `B`.

The function has a third parameter `Solution` of mode `out`. It will have
one of the following values after the function `Solve` returns:

- `None`. If the system is inconsistent for any vector in `B`.

- `Infinite`. If `A` has more columns than rows or if one of its pivots is
  not on the main diagonal, then `A` has one or more free variables and
  thus the system of linear equations will have an infinite number of solutions.
  If `A` has free variables, their vectors are not returned in any `out` parameter.

- `Unique`. A **x** = **b** has exactly one solution for all vectors in `B`.

## Trace

The trace of a matrix or 2-D tensor is the sum of the elements on the main
diagonal and can be computed with the function `Trace`.
The optional parameter `Offset` can be given to specify the diagonal to use

## Main diagonal

Function `Main_Diagonal` returns a 1-D tensor filled with the elements on
the main diagonal of a 2-D tensor. The diagonal to use can be specified with
the optional parameter `Offset`.

## Decompositions

!!! bug "TODO"